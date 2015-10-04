

module MyModule
  def attribute(name, &block)
    #recursively calling attribute(), passing a block that returns the default argument
    return name.each_pair{|k, v| attribute(k){v} } if name.is_a? Hash
    
    #define a method with proc object as argument
    define_method("__#{name}__", block || proc{nil} )
    
    code = %Q{
      attr_writer :#{name}
      
      def #{name}?
        true unless #{name}.nil?
      end
      
      #@#{name} = __#{name}__   assign the return value of the method: __#{name}__ to @#{name}
      def #{name}
         defined?(@#{name})? @#{name} : @#{name} = __#{name}__
      end
    }
    
    class_eval code
  end
end

#then we can use this method:
# c = Class::new {
  # extend MyModule
  # attribute 'a'
        # }
# o = c::new
# 
# o.a = 42
# puts o.a
# puts o.a?

c = Class::new {
      extend MyModule
      attribute('a'){ fortytwo }
      def fortytwo
        42
      end
    
    }

o = c::new
p o.a

#Or we can use this way to do validation before assignment
module CheckedAttributes
  def attr_check(name, &block)
    define_method("valid?"){|value| block.call(value) }
    
    code = %Q{
      attr_reader :#{name}
      
      def #{name}=(value)
        raise 'Invalid attribute' unless valid?(value)
        @#{name} = value
      end
    }
    
    class_eval(code)
  end
end

#to use this method
class Person
  extend CheckedAttributes
  
  attr_check :age do |v|
    v >= 18
  end
end
  
person = Person.new
person.age = 20
p person.age

