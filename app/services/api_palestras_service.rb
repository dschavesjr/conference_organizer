class ApiPalestrasService

    URL = 'http://localhost:3000/api/v1/palestras'

    def self.save_palestras_json_file(json)
        res = RestClient.post(URL,
            {
                arquivo: json,
                multipart: true
            })
        JSON.parse(res.body) if res.code == 200
    end
end