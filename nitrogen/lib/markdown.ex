defmodule Markdown do
  use Rustler, otp_app: :nitrogen, crate: "markdown_shim"

  @moduledoc """
  This module contains the rust-based markdown render functions.
  """

  # When your NIF is loaded, it will override this function.
  @spec render_and_extract_links(binary(), [{binary(), integer()}]) :: {binary(), list()}
  def render_and_extract_links(_str, _list), do: :erlang.nif_error(:nif_not_loaded)
end
