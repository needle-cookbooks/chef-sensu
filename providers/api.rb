include Sensu

action :silence do
    Chef::Log.info("Silencing sensu notifications for #{new_resource.node_id}")
    api.silence_node(new_resource.node_id)
    new_resource.updated_by_last_action(true)
end

action :unsilence do
    Chef::Log.info("Unsilencing sensu notifications for #{new_resource.node_id}")
    api.unsilence_node(new_resource.node_id)
    new_resource.updated_by_last_action(true)
end

private
def api
    @@api ||= Sensu::API.new(@new_resource.sensu_api_url)
end
