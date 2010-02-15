# This takes an item that may be in an array or string.
# If it's in an array, return it's first element, or '' if it's not
# Otherwise, just return it.
def unarrayify(obj)
  if obj.kind_of? Array
    if obj.size > 0
      obj[0]
    else
      ""
    end
  else
    obj
  end
end
