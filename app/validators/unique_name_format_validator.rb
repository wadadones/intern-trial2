class UniqueNameFormatValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A[a-z0-9_]+\z/i
      record.errors[attribute] << (options[:message] || "は不正な値です")
    end
  end
end
