function response_decorator( resp )
  -- Lấy các giá trị cần thiết
  local statusCode = tostring(resp:status())
  local path = resp:request():path()
  local method = resp:request():method()
  local email = resp:request():headers("X-Email-Id")

  -- Xử lý trường hợp không có header X-Email-Id
  if email == nil or email == "" then
    email = "unknown"
  end

  -- Tìm metric đã khai báo và tăng giá trị
  -- Tên metric phải khớp với tên trong extra_metrics
  local metric = metrics:counter("http_requests_by_email")
  if metric then
    -- Các label phải đúng thứ tự đã khai báo
    metric:with(email, path, method, statusCode):inc()
  end
end