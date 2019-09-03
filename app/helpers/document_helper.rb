# frozen_string_literal: true

module DocumentHelper
  def partial_for_document(document)
    underscore_class_name = document.class.to_s.underscore
    ["shared/documents/full/#{underscore_class_name}", locals: { underscore_class_name => @document }]
  end
end
