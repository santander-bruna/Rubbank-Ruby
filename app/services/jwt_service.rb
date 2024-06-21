class JsonWebToken  
    def encode(payload, exp = 24.hours.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, ENV['JWT_SECRET_KEY'])
    end
  
    def decode(request)
        header = request.headers['Authorization']
        if header
            token = header.split(" ")[1]
            begin
                JWT.decode(token, ENV['JWT_SECRET_KEY'])
            rescue JWT::DecodeError
                nil
            end
        end
    end
end