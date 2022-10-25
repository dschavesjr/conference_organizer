class UploadPalestrasParser
    attr_reader :palestras
  
    def initialize(arquivo, type = nil)
      @palestras = []
      @arquivo = arquivo
      content_type = get_content_type(type)
      parser_json if content_type == 'application/json'
    end
  
    def parser_json
      @palestras = JSON.parse(sanitize_string(arquivo))
    end
  
    def arquivo
      return @arquivo.download if @arquivo.is_a?(ActiveStorage::Attached)
      return @arquivo.read if @arquivo.is_a?(ActionDispatch::Http::UploadedFile)
      return @arquivo.read if @arquivo.respond_to?(:read)
  
      @arquivo
    end
  
    def sanitize_string(arquivo)
      arquivo.gsub(/\A{|"arquivo":|\}\Z/, '')
    end
  
    def get_content_type(type)
      return type if type.present?
      return @arquivo.content_type if @arquivo.respond_to?(:content_type)
      return @arquivo.blob.content_type if @arquivo.respond_to?(:blob)
    end
  end