# frozen_string_literal: true

module Mcp
  module Tools
    class InstructionsTool < MCP::Tool
      tool_name "instructions"
      description "Returns guidance on how to use this MCP server. Call this first."

      def self.call
        text = <<~TEXT
          # Twine MCP Server

          Twine is a platform for managing organisations, social groups, and businesses.
          Each **Platform** is a separate organisation. Platforms have members, projects, tasks, and meetings.

          ## Workflow

          1. Call `get_overview` to see all platforms with their IDs and high-level status.
          2. Use platform IDs to drill into projects (`list_projects`) or meetings (`list_meetings`).
          3. Use project and task IDs returned by `list_projects` to update, complete, or delete items.
          4. Use meeting IDs returned by `list_meetings` to update or delete meetings.

          ## Projects & Tasks

          - Each platform has a **feeling** (1–5) expressing how it's going overall:
            1 = Stuck, 2 = Struggling, 3 = OK, 4 = Going well, 5 = Excellent
          - Projects belong to a platform. Tasks belong to a project and can be marked completed.

          ## Meetings

          - Meetings belong to a platform. `starts_at` and `ends_at` are ISO 8601 datetime strings (e.g. "2026-05-01T14:00:00").
          - `location` can be a place name or a URL (Zoom, Google Meet, etc.).

          ## Available Tools

          | Tool | Description |
          |------|-------------|
          | `get_overview` | All platforms with member/project/meeting counts and project feelings |
          | `list_projects` | Projects and tasks for a platform |
          | `create_project` | Create a new project |
          | `update_project` | Update a project's title or description |
          | `update_platform_feeling` | Update how a platform is going overall (1–5) |
          | `delete_project` | Delete a project and all its tasks |
          | `create_task` | Add a task to a project |
          | `update_task` | Rename a task or mark it completed/incomplete |
          | `delete_task` | Delete a task |
          | `list_meetings` | Meetings for a platform (upcoming and past) |
          | `create_meeting` | Create a meeting |
          | `update_meeting` | Update a meeting's title, time, or location |
          | `delete_meeting` | Delete a meeting |
        TEXT

        MCP::Tool::Response.new([ { type: "text", text: text } ])
      end
    end
  end
end
