# frozen_string_literal: true

module Mcp
  module Tools
    FEELING_LABELS = {
      1 => "Stuck",
      2 => "Struggling",
      3 => "OK",
      4 => "Going well",
      5 => "Excellent"
    }.freeze

    class GetOverviewTool < MCP::Tool
      tool_name "get_overview"
      description "Returns an overview of all platforms: feeling, member count, project status, and meeting activity."

      def self.call
        platforms = Platform.includes(projects: :tasks, memberships: :user).order(:name)

        lines = platforms.map do |platform|
          projects = platform.projects
          upcoming_meetings = platform.meetings.upcoming.count
          past_meetings = platform.meetings.past.count
          feeling = platform.feeling ? "#{FEELING_LABELS[platform.feeling]} (#{platform.feeling}/5)" : "not set"

          platform_lines = [
            "## #{platform.name} (ID: #{platform.id})",
            "   Feeling: #{feeling}",
            "   Members: #{platform.memberships.size}",
            "   Meetings: #{upcoming_meetings} upcoming, #{past_meetings} past"
          ]

          if projects.any?
            platform_lines << "   Projects:"
            projects.each do |project|
              tasks = project.tasks
              done = tasks.count(&:completed?)
              total = tasks.size
              platform_lines << "     [#{project.id}] #{project.title} — #{done}/#{total} tasks done"
            end
          else
            platform_lines << "   Projects: none"
          end

          platform_lines.join("\n")
        end

        text = lines.any? ? lines.join("\n\n") : "No platforms found."
        MCP::Tool::Response.new([ { type: "text", text: text } ])
      end
    end
  end
end
