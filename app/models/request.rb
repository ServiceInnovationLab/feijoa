# frozen_string_literal: true

class Request < ApplicationRecord

  state_machine :initial => :initiated do
    event :view do
      transition :initiated => :received
    end
    event :respond do
      transition :received => :responded
    end
    event :decline do
      transition :received => :declined
      transition :responded => :declined
    end
    event :cancel do
      transition :initiated => :cancelled
      transition :received => :cancelled
      transition :responded => :cancelled
    end
  end


end
