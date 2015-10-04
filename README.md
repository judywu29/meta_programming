Extend and define the attribute method
===========================================
To define a single method 'attribute' which behaves much like the built-in 'attr', but whose properties require delving
deep into the depths of meta-ruby. Usage of the 'attribute' method follows the general form of
	       
	       class C
	         attribute 'a'
	       end
	       
	       o = C::new
	       o.a = 42  # setter - sets @a
	       o.a       # getter - gets @a 
	       o.a?      # query  - true if @a
	       
 but reaches much farther than the standard 'attr' method. 'attribute' must provide getter, setter, and query to instances
	    
	      def koan_1
	        c = Class::new {
	          attribute 'a'
	        }
	
	        o = c::new
	
	        assert{ not o.a? }
	        assert{ o.a = 42 }
	        assert{ o.a == 42 }
	        assert{ o.a? }
	      end
      
'attribute' must provide a method for providing a default value as hash
	    
	      def koan_6
	        c = Class::new {
	          attribute 'a' => 42
	        }
	
	        o = c::new
	
	        assert{ o.a == 42 }
	        assert{ o.a? }
	        assert{ (o.a = nil) == nil }
	        assert{ not o.a? }
	      end
	   
'attribute' must provide a method for providing a default value as block which is evaluated at instance level 
	    
	      def koan_7
	        c = Class::new {
	          attribute('a'){ fortytwo }
	          def fortytwo
	            42
	          end
	        }
	
	        o = c::new
	
	        assert{ o.a == 42 }
	        assert{ o.a? }
	        assert{ (o.a = nil) == nil }
	        assert{ not o.a? }
	      end
      
Solution
===============

We can extend Object with a method that relies on methods definded in module and the method is available 
in places where it really didn't ought to be. 
and then we can use class_eval(), which just executes the code in the context of the class where we can 
define our setter, getter and querier there. 

