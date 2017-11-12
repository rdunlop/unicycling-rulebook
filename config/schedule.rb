every 1.day, at: '12am', roles: [:db] do
  rake "update_proposal_states"
end

every 1.week, roles: [:db] do
  rake "encryption:renew_and_update_certificate"
end
