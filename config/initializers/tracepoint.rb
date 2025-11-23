if ENV["TRACE_RAILS"] == "true"
  tp = TracePoint.new(:call) do |tp|
    if !tp.defined_class.to_s.include?("Puma") ||
       tp.defined_class.to_s.include?("Time")
      Rails.logger.info "CALL #{tp.defined_class}##{tp.method_id}"
    end
  end
  tp.enable
end
