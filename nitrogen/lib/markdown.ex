defmodule Markdown do
  use Rustler, otp_app: :nitrogen, crate: "markdown_shim"

  # When your NIF is loaded, it will override this function.
  def render_simple(_str), do: :erlang.nif_error(:nif_not_loaded)
end
