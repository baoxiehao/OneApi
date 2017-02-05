defmodule OneApi.Time do
  @moduledoc false

  def format(time) do
    # "2017-02-05T10:20:30+08:00"
    ftime = Regex.run(~r/\d{4}-\d{2}-\d{2}/, time)
    if ftime, do: ftime |> List.first, else: time
  end
end