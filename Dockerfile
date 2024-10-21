# ARG declarations for Elixir, Erlang, and Debian versions
ARG ELIXIR_VERSION=1.17.2
ARG OTP_VERSION=27.0
ARG DEBIAN_VERSION=bullseye-20240701-slim

ARG BUILDER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-debian-${DEBIAN_VERSION}"
ARG RUNNER_IMAGE="debian:${DEBIAN_VERSION}"

# Builder stage
FROM ${BUILDER_IMAGE} as builder

# Install build dependencies and Node.js (with npm)
RUN apt-get update -y && \
  apt-get install -y build-essential git curl \
  && curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
  && apt-get install -y nodejs \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Install Hex and Rebar
RUN mix local.hex --force && \
  mix local.rebar --force

# Set environment to production
ENV MIX_ENV="prod"

# Install mix dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV
RUN mkdir config

# Copy compile-time config files before compiling dependencies
COPY config/config.exs config/prod.exs config/
RUN mix deps.compile

# Copy the priv directory
COPY priv priv

# Copy the lib directory
COPY lib lib

# Install npm dependencies in the assets directory
COPY assets/package.json assets/package-lock.json ./assets/
RUN cd assets && npm install

# Copy the assets folder
COPY assets assets

# Compile assets (Tailwind, Esbuild, etc.)
RUN mix assets.deploy

# Compile the Elixir release
RUN mix compile

# Copy runtime configuration files
COPY config/runtime.exs config/

# Copy the rel directory for release
COPY rel rel

# Build the release
RUN mix release

# Start a new stage for the final runtime image
FROM ${RUNNER_IMAGE}

# Install runtime dependencies
RUN apt-get update -y && \
  apt-get install -y libstdc++6 openssl libncurses5 locales ca-certificates \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Set the working directory
WORKDIR "/app"
RUN chown nobody /app

# Set environment to production
ENV MIX_ENV="prod"

# Copy the release from the builder stage
COPY --from=builder --chown=nobody:root /app/_build/prod/rel/birdpaw ./

# Set the user to nobody for security
USER nobody

# Set the default command to start the Phoenix server
CMD ["/app/bin/server"]
