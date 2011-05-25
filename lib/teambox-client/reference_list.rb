# Methods for handling references list
module ReferenceList
  # Generate references hash from JSON data
  def generate_references(data)
    @references = {}
    @references.tap { |h| data.each {|ref| h[ref['type'] + ref['id'].to_s] = Teambox.create_model(ref['type'], ref, self) } }
  end
  
  # References resource in the current Teambox::ResultSet
  def set_reference(klass, resource)
    real_resource = if resource.is_a? Teambox::Resource
      resource
    else
      Teambox.const_get(klass).new(resource, self)
    end
    
    @references[klass.to_s + real_resource.id.to_s] = real_resource
    real_resource
  end
  
  # Gets a referenced object. e.g:
  #   get_reference('User', 1)
  def get_reference(klass, id)
    @references[klass.to_s + (id||'').to_s]
  end
  
  # get reference based on data. Makes new resource if reference does not exist. e.g.
  #   get_or_make_reference('User', @data, 'user_id')
  def get_or_make_reference(klass, data, field_id)
    get_reference(klass, data[field_id]) || set_reference(klass, {}.merge({'id' => data[field_id]}))
  end
  
  # get a list of references based on data. Makes a new resource for each references which doesnot exist.
  def get_or_make_references(klass, data, field_id, field_data=nil)
    if data[field_data]
      data[field_data].map do |object|
        get_reference(klass, object['id']) ||
        set_reference(klass, object)
      end
    elsif data[field_id]
      data[field_id].map do |object_id|
        get_reference(klass, object_id) ||
        set_reference(klass, {'id' => object_id})
      end
    else
      []
    end
  end
end