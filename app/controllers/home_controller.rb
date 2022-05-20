class HomeController < ApplicationController
  def index
  end

  def result
    @result = params[:result]
  end

  def process_text
    @filename = params[:file]
    if @filename.respond_to?(:read)
      @lines = @filename.read
    elsif @filename.respond_to?(:path)
      @lines = File.read(@filename.path)
    else
      logger.error "Bad file_data: #{@filename.class.name}: #
    {@filename.inspect}"
    end
    str = ''
    str = params[:string] if params[:string].present?
    str = @lines if @lines.present?

    if params[:method_process] == '1'
      result = method_1 str
    else
      result = method_2 str
    end
    render 'result', :locals => {result: result}
  end

  # esto se debe hacer en un servicio
  private
  def method_1 str
    str.split.group_by(&:itself).transform_values(&:count).sort_by{|_key, value| value}.reverse.to_h
  end

  def method_3 str
    str.split.tally.sort_by{|_key, value| value}.reverse
  end

  def method_2 str
    hash_return = {}
    array = str.split
    array.each do |item|
      if hash_return.has_key?(item)
        hash_return[item] =hash_return[item]+1
      else
        hash_return[item] = 1
      end
    end
    hash_return.sort_by{|_key, value| value}.reverse.to_h
  end
end
