class EventsWorker
  include ProposalsHelper
  include Rails.application.routes.url_helpers
  include Sidekiq::Worker

  sidekiq_options queue: :high_priority

  STARTVOTATION = 'startvotation'.freeze
  ENDVOTATION = 'endvotation'.freeze

  def perform(*args)
    params = args[0]
    case params['action']
    when STARTVOTATION
      start_votation(params['event_id'])
    when ENDVOTATION
      end_votation(params['event_id'])
    else
      puts '==Action not found!=='
    end
  end

  # fa partire la votazione di una proposta
  def start_votation(event_id)
    event = Event.find(event_id)
    event.start_votation
  end

  # terminate proposal votation
  def end_votation(event_id)
    event = Event.find(event_id)
    event.end_votation
  end
end
