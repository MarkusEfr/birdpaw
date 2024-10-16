defmodule BirdpawWeb.Page.Index do
  @moduledoc """
  This module is used to render the index page.
  """
  use BirdpawWeb, :live_view

  import Birdpaw.Presale
  import Birdpaw.PresaleUtil

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
       contract_address: "0x32e4A492068beE178A42382699DBBe8eEF078800",
       presale_form: %{
         is_open?: false,
         session_id: nil,
         wallet_address: nil,
         birdpaw_amount: nil,
         amount: 0.0,
         qr_code_base64: nil,
         is_confirmed?: false,
         payment_method: "ETH",
         payment_variant: nil
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
       order: nil
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
        "set_payment_variant",
        %{"variant" => payment_variant},
        %{assigns: %{presale_form: presale_form}} = socket
      ) do
    {:noreply, assign(socket, :presale_form, %{presale_form | payment_variant: payment_variant})}
  end

  @impl true
  def handle_event(
        "select-payment-method",
        %{"method" => method},
        %{assigns: %{presale_form: presale_form}} = socket
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
           if(presale_form.birdpaw_amount == nil, do: "0", else: presale_form.birdpaw_amount)
           |> String.to_integer()
           |> calculate_amount(payment_method)
     })}
  end

  @impl true
  def handle_event(
        "select-payment-method-type",
        %{"payment_method" => payment_method},
        %{assigns: %{presale_form: %{birdpaw_amount: birdpaw_amount} = presale_form}} = socket
      ) do
    {:noreply,
     socket
     |> assign(:presale_form, %{
       presale_form
       | payment_method: payment_method,
         amount:
           if(birdpaw_amount == nil, do: "0", else: birdpaw_amount)
           |> String.to_integer()
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
        %{assigns: %{presale_form: %{payment_variant: payment_variant} = presale_form}} = socket
      ) do
    payment_method = socket.assigns[:presale_form][:payment_method] || "ETH"

    birdpaw_amount =
      String.to_integer(birdpaw_amount)

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
        %{"birdpaw_amount" => birdpaw_amount, "wallet_address" => wallet_address} = params,
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
        } = _params,
        %{assigns: %{presale_form: presale_form}} = socket
      ) do
    order_uuid = Ecto.UUID.generate()
    wei_amount = Map.get(presale_form, :wei_amount, 0)

    qr_code_binary =
      case {wallet_address, wei_amount} do
        {_, ""} -> nil
        _ -> generate_qr_code({wei_amount, amount}, order_uuid, payment_method)
      end

    presale_form = %{presale_form | qr_code_base64: qr_code_binary}

    order = %{
      wallet_address: wallet_address,
      birdpaw_amount: birdpaw_amount,
      payment_method: payment_method,
      amount: amount,
      is_confirmed?: true,
      timestamp: DateTime.utc_now(),
      uuid: order_uuid,
      order_state: "pending",
      qr_code_base64: presale_form[:qr_code_base64]
    }

    {:ok, _created_order} = create_presale_order(order)

    {:noreply,
     socket
     |> assign(order: order, presale_form: Map.merge(presale_form, order))}
  end

  @impl true
  def handle_event(
        "check_balances_result",
        %{"address" => address, "eth_balance" => eth_balance, "nfts" => nfts, "tokens" => tokens} =
          params,
        %{assigns: %{wallet_info: wallet_info, presale_form: presale_form}} = socket
      ) do
    # Merge the incoming params into the wallet_info map
    updated_wallet_info = Map.merge(wallet_info, params)

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
end
