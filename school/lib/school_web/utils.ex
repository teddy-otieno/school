defmodule SchoolWeb.Utils do
  def send_error(conn, changeset, embedded \\ []) do
    dbg(changeset)

    error_messages =
      Ecto.Changeset.traverse_errors(changeset, fn _changeset, field, {msg, opts} ->
        %{Atom.to_string(field) => msg}
      end)

    conn
    |> Plug.Conn.put_resp_content_type("application/json")
    |> Plug.Conn.send_resp(400, Jason.encode!(%{message: "Failed", errors: error_messages}))
  end

  @doc """
    Sample File Upload
    %Plug.Upload{
      path: "c:/Users/Otieno/AppData/Local/Temp/plug-1709-n2CI/multipart-1709647623-47866923725-3",
      content_type: "image/jpeg",
      filename: "1662990761042.jpg"
    }
  """

  @spec save_media(:product_item, %Plug.Upload{}) :: binary()
  def save_media(:product_item, %Plug.Upload{} = file) do
    # Move the file to the upload directory
    output_dir = Path.relative("./output/product_item")

    unless File.exists?(output_dir) do
      File.mkdir_p(output_dir)
    end

    # Write the file, generate a uuid
    file_extension = Path.extname(file.filename)
    uuid = UUID.uuid4(:hex)

    # Save file to save
    output_file = Path.join([output_dir, uuid <> file_extension])
    File.cp(file.path, output_file)

    output_file
  end

  def remove_media(file_path) do
    File.rm(Path.relative(file_path))
  end
end
