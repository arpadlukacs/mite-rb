class Mite::TimeEntry < Mite::Base
  
  def service
    @service ||= Mite::Service.find(service_id) unless service_id.blank?
  end
  
  def service=(service)
    self.service_id = service ? service.id : nil
    @service = service
  end
  
  def project
    @project ||= Mite::Project.find(project_id) unless project_id.blank?
  end
  
  def project=(project)
    self.project_id = project ? project.id : nil
    @project = project
  end
  
  def customer
    @customer ||= begin
      p = project
      p.customer unless p.blank?
    end
  end
  
  def tracking?
    !!attributes["tracker"]
  end
  
  def start_tracker
    attributes["tracker"] = Mite::Tracker.start(id) || nil
  end
  
  def stop_tracker
    Mite::Tracker.stop if tracking?
  end
  
  def load(attr)
    super(attr)
    if attributes["tracking"]
      attributes["tracker"] = Mite::Tracker.new.load(attributes.delete("tracking").attributes)
    end
    self
  end
  
  class << self
    def find_every(options={})
      return super(options) if !options[:params] || !options[:params][:group_by]
      Mite::TimeEntryGroup.all(options)
    end
  end
end

require 'mite/time_entry/bookmark'