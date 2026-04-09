# frozen_string_literal: true

module Mcp
  module Tools
    class ListProjectsTool < MCP::Tool
      tool_name "list_projects"
      description "Lists all projects and their tasks for a given platform."

      input_schema(
        properties: {
          platform_id: { type: "integer", description: "The platform ID (from get_overview)" }
        },
        required: [ "platform_id" ]
      )

      def self.call(platform_id:)
        platform = Platform.find_by(id: platform_id)
        return error("Platform #{platform_id} not found") unless platform

        projects = platform.projects.includes(:tasks).order(:title)
        return text("No projects yet for #{platform.name}.") if projects.none?

        lines = [ "# Projects for #{platform.name}\n" ]

        projects.each do |project|
          feeling = project.feeling ? "#{FEELING_LABELS[project.feeling]} (#{project.feeling}/5)" : "not set"
          lines << "## [#{project.id}] #{project.title}"
          lines << "   Description: #{project.description.presence || '—'}"
          lines << "   Feeling: #{feeling}"

          tasks = project.tasks.order(completed: :asc, created_at: :asc)
          if tasks.any?
            lines << "   Tasks:"
            tasks.each do |task|
              status = task.completed? ? "✓" : "○"
              lines << "     [#{task.id}] #{status} #{task.title}"
            end
          else
            lines << "   Tasks: none"
          end

          lines << ""
        end

        text(lines.join("\n"))
      end

      def self.text(str) = MCP::Tool::Response.new([ { type: "text", text: str } ])
      def self.error(str) = MCP::Tool::Response.new([ { type: "text", text: "Error: #{str}" } ], error: true)
    end

    class CreateProjectTool < MCP::Tool
      tool_name "create_project"
      description "Creates a new project for a platform."

      input_schema(
        properties: {
          platform_id:  { type: "integer", description: "The platform ID" },
          title:        { type: "string",  description: "Project title" },
          description:  { type: "string",  description: "Optional project description" }
        },
        required: [ "platform_id", "title" ]
      )

      def self.call(platform_id:, title:, description: nil)
        platform = Platform.find_by(id: platform_id)
        return error("Platform #{platform_id} not found") unless platform

        project = platform.projects.build(title: title, description: description)
        if project.save
          text("Created project [#{project.id}] \"#{project.title}\" on #{platform.name}.")
        else
          error(project.errors.full_messages.to_sentence)
        end
      end

      def self.text(str) = MCP::Tool::Response.new([ { type: "text", text: str } ])
      def self.error(str) = MCP::Tool::Response.new([ { type: "text", text: "Error: #{str}" } ], error: true)
    end

    class UpdateProjectTool < MCP::Tool
      tool_name "update_project"
      description "Updates a project's title or description."

      input_schema(
        properties: {
          project_id:  { type: "integer", description: "The project ID" },
          title:       { type: "string",  description: "New title" },
          description: { type: "string",  description: "New description" }
        },
        required: [ "project_id" ]
      )

      def self.call(project_id:, title: nil, description: nil)
        project = Project.find_by(id: project_id)
        return error("Project #{project_id} not found") unless project

        attrs = {}
        attrs[:title] = title if title
        attrs[:description] = description unless description.nil?

        if project.update(attrs)
          text("Updated project [#{project.id}] \"#{project.title}\".")
        else
          error(project.errors.full_messages.to_sentence)
        end
      end

      def self.text(str) = MCP::Tool::Response.new([ { type: "text", text: str } ])
      def self.error(str) = MCP::Tool::Response.new([ { type: "text", text: "Error: #{str}" } ], error: true)
    end

    class UpdateProjectFeelingTool < MCP::Tool
      tool_name "update_project_feeling"
      description "Updates how a project is going. Feeling is 1–5: 1=Stuck, 2=Struggling, 3=OK, 4=Going well, 5=Excellent."

      input_schema(
        properties: {
          project_id: { type: "integer", description: "The project ID" },
          feeling:    { type: "integer", description: "1 (Stuck) to 5 (Excellent)", enum: [ 1, 2, 3, 4, 5 ] }
        },
        required: [ "project_id", "feeling" ]
      )

      def self.call(project_id:, feeling:)
        project = Project.find_by(id: project_id)
        return error("Project #{project_id} not found") unless project

        unless (1..5).include?(feeling)
          return error("Feeling must be between 1 and 5.")
        end

        project.update!(feeling: feeling)
        label = FEELING_LABELS[feeling]
        text("Updated feeling for \"#{project.title}\" to #{label} (#{feeling}/5).")
      end

      def self.text(str) = MCP::Tool::Response.new([ { type: "text", text: str } ])
      def self.error(str) = MCP::Tool::Response.new([ { type: "text", text: "Error: #{str}" } ], error: true)
    end

    class DeleteProjectTool < MCP::Tool
      tool_name "delete_project"
      description "Deletes a project and all its tasks."

      input_schema(
        properties: {
          project_id: { type: "integer", description: "The project ID" }
        },
        required: [ "project_id" ]
      )

      def self.call(project_id:)
        project = Project.find_by(id: project_id)
        return error("Project #{project_id} not found") unless project

        title = project.title
        project.destroy!
        text("Deleted project \"#{title}\" and all its tasks.")
      end

      def self.text(str) = MCP::Tool::Response.new([ { type: "text", text: str } ])
      def self.error(str) = MCP::Tool::Response.new([ { type: "text", text: "Error: #{str}" } ], error: true)
    end
  end
end
