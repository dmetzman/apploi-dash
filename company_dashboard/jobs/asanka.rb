#!/usr/bin/env ruby
require 'asana'
require 'json'
 
# You need to enter your API key to query Asana.
# You can find that by clicking on your name in the bottom left and selecting Account Settings.
# Click on the Apps tab.
api_key = '47Fs9YOq.mA8Zd0hmoN2gBejjDuimG66'
# The name of the workspace you would like to query. Case sensitive so you might need to go to Edit Workspace Settings to see.
workspace_name = 'apploi.com'
# Number of tasks to show
num_tasks = 5
 
Asana.configure do |client|
	client.api_key = api_key
end
 
 
# get workspace id
workspace_id = nil
workspaces = Asana::Workspace.all
workspaces.each do |workspace|
	if workspace.attributes['name'] == workspace_name
		workspace_id = workspace.attributes['id']
	end
end
# set workspace
workspace = Asana::Workspace.find(workspace_id)
 
# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '30m', :first_in => 0 do |job|
	list = Array.new
	tasks = workspace.tasks(:me)
 
	i = 0
	tasks.each do |task|
		task_detail = Asana::Task.find(task.attributes['id'])
		if task_detail.attributes['assignee_status'] == 'today'
			if task_detail.attributes['completed'] == true
				icon = 'icon-check'
			else
				icon = 'icon-check-empty'
				list.push({label: task.attributes['name'], icon: icon}) # moved here due to no longer being able to archive tasks
				i += 1 # moved here due to no longer being able to archive tasks
			end
		end
		break if i == num_tasks
	end
 
	send_event('asana_tasks', {items: list})
end