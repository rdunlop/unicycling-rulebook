desc "This task is called by the Heroku scheduler add-on"
task update_proposal_states: :environment do
    puts "Updating proposal:states ..."
    Proposal.update_states
    puts "done."
end
