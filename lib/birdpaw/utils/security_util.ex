defmodule Birdpaw.SecurityUtil do
  @moduledoc """
  This module contains utility functions for security, including hashing and verifying
  passwords using Erlang's :crypto module.
  """

  @iterations 100_000
  @hash_alg :sha256
  @key_length 32

  @doc """
  Hashes a plain-text password using the :crypto module.
  Generates a salted hash using HMAC and PBKDF2 to store securely.
  """
  def hash_password(plain_password) do
    # Generate a random 16-byte salt
    salt = :crypto.strong_rand_bytes(16)
    hashed_password = pbkdf2(plain_password, salt, @iterations, @key_length, @hash_alg)
    # Combine the salt and hashed password for storage
    Base.encode64(salt <> hashed_password)
  end

  @doc """
  Verifies the provided `master_password` by comparing it with the stored hashed password.
  Returns `true` if the password is correct, `false` otherwise.
  """
  def verify_master_password(master_password, stored_hash) do
    case Base.decode64(stored_hash) do
      {:ok, <<salt::binary-size(16), stored_hashed_password::binary>>} ->
        hashed_password = pbkdf2(master_password, salt, @iterations, @key_length, @hash_alg)
        :crypto.hash_equals(stored_hashed_password, hashed_password)

      _ ->
        false
    end
  end

  @doc """
  Implements PBKDF2 (Password-Based Key Derivation Function 2) using the :crypto module.
  """
  defp pbkdf2(password, salt, iterations, key_length, hash_alg) do
    :crypto.pbkdf2_hmac(hash_alg, password, salt, iterations, key_length)
  end
end
