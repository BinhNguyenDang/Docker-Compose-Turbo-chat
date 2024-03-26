class ApplicationController < ActionController::Base
   # Installing pagy  
  include Pagy::Backend
    before_action :turbo_frame_request_variant
  
    private
    # The turbo frame variant is used to optimize performance for requests made with Turbo Frame,
    # a technique for improving the performance of web applications by reducing the amount of data
    # that needs to be transmitted between the server and the browser.
    #
    # This method is called before each action in the ApplicationController, and it checks whether
    # the current request is a turbo frame request. If it is, it sets the request variant to :turbo_frame,
    # which will cause the response to be rendered using the Turbo Frame format.
    def turbo_frame_request_variant
      request.variant = :turbo_frame if turbo_frame_request?
    end
  end
  