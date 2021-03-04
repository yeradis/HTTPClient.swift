# HTTPClient

Basic HTTPClient allowing request and response interceptors, useful for adding headers, logging or checking information
. 

Also the client use a default response handler but will be only used if the HTTPRequest does not provide it

This is useful for example imagine you have request to different versions of the API but for each version the error response is different
or you want to treat http status codes in a different way for each request

See `HTTPClientTests` for reference