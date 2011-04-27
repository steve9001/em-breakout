class Exception
  def pretty
    begin
      %Q[\n#{self.class} (#{self.message}):\n    #{backtrace.join("\n    ")}\n]
    rescue Exception => e
      "error in Exception#pretty: #{e}"
    end
  end
end

