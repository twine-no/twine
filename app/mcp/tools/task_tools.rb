# frozen_string_literal: true

module Mcp
  module Tools
    class CreateTaskTool < MCP::Tool
      tool_name "create_task"
      description "Adds a task to a project."

      input_schema(
        properties: {
          project_id: { type: "integer", description: "The project ID" },
          title:      { type: "string",  description: "Task title" }
        },
        required: [ "project_id", "title" ]
      )

      def self.call(project_id:, title:)
        project = Project.find_by(id: project_id)
        return error("Project #{project_id} not found") unless project

        task = project.tasks.build(title: title)
        if task.save
          text("Added task [#{task.id}] \"#{task.title}\" to \"#{project.title}\".")
        else
          error(task.errors.full_messages.to_sentence)
        end
      end

      def self.text(str) = MCP::Tool::Response.new([ { type: "text", text: str } ])
      def self.error(str) = MCP::Tool::Response.new([ { type: "text", text: "Error: #{str}" } ], error: true)
    end

    class UpdateTaskTool < MCP::Tool
      tool_name "update_task"
      description "Renames a task or marks it completed or incomplete."

      input_schema(
        properties: {
          task_id:   { type: "integer", description: "The task ID" },
          title:     { type: "string",  description: "New title" },
          completed: { type: "boolean", description: "true to complete, false to reopen" }
        },
        required: [ "task_id" ]
      )

      def self.call(task_id:, title: nil, completed: nil)
        task = Task.find_by(id: task_id)
        return error("Task #{task_id} not found") unless task

        attrs = {}
        attrs[:title] = title if title
        attrs[:completed] = completed unless completed.nil?

        if task.update(attrs)
          status = task.completed? ? "completed" : "open"
          text("Updated task [#{task.id}] \"#{task.title}\" (#{status}).")
        else
          error(task.errors.full_messages.to_sentence)
        end
      end

      def self.text(str) = MCP::Tool::Response.new([ { type: "text", text: str } ])
      def self.error(str) = MCP::Tool::Response.new([ { type: "text", text: "Error: #{str}" } ], error: true)
    end

    class DeleteTaskTool < MCP::Tool
      tool_name "delete_task"
      description "Deletes a task."

      input_schema(
        properties: {
          task_id: { type: "integer", description: "The task ID" }
        },
        required: [ "task_id" ]
      )

      def self.call(task_id:)
        task = Task.find_by(id: task_id)
        return error("Task #{task_id} not found") unless task

        title = task.title
        task.destroy!
        text("Deleted task \"#{title}\".")
      end

      def self.text(str) = MCP::Tool::Response.new([ { type: "text", text: str } ])
      def self.error(str) = MCP::Tool::Response.new([ { type: "text", text: "Error: #{str}" } ], error: true)
    end
  end
end
