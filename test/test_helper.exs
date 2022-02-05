ExUnit.start()

Mox.defmock(HTTPoison.BaseMock, for: HTTPoison.Base)

Application.put_env(:travelpass, :http_client, HTTPoison.BaseMock)
