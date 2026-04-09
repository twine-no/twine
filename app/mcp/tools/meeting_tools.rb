# frozen_string_literal: true

module Mcp
  module Tools
    class ListMeetingsTool < MCP::Tool
      tool_name "list_meetings"
      description "Lists upcoming and past meetings for a platform."

      input_schema(
        properties: {
          platform_id: { type: "integer", description: "The platform ID (from get_overview)" }
        },
        required: [ "platform_id" ]
      )

      def self.call(platform_id:)
        platform = Platform.find_by(id: platform_id)
        return error("Platform #{platform_id} not found") unless platform

        upcoming = platform.meetings.upcoming.order(:starts_at)
        past = platform.meetings.past.order(starts_at: :desc).limit(10)
        unscheduled = platform.meetings.unscheduled.order(:created_at)

        lines = [ "# Meetings for #{platform.name}\n" ]

        if upcoming.any?
          lines << "## Upcoming"
          upcoming.each { |m| lines << format_meeting(m) }
          lines << ""
        end

        if unscheduled.any?
          lines << "## Unscheduled"
          unscheduled.each { |m| lines << format_meeting(m) }
          lines << ""
        end

        if past.any?
          lines << "## Past (last #{past.size})"
          past.each { |m| lines << format_meeting(m) }
        end

        lines << "No meetings found." if upcoming.none? && past.none? && unscheduled.none?

        text(lines.join("\n"))
      end

      def self.format_meeting(meeting)
        time = if meeting.starts_at
          ends = meeting.ends_at ? " → #{meeting.ends_at.strftime("%H:%M")}" : ""
          meeting.starts_at.strftime("%Y-%m-%d %H:%M") + ends
        else
          "no date set"
        end
        location = meeting.location.present? ? " @ #{meeting.location_name}" : ""
        "  [#{meeting.id}] #{meeting.title} — #{time}#{location}"
      end

      def self.text(str) = MCP::Tool::Response.new([ { type: "text", text: str } ])
      def self.error(str) = MCP::Tool::Response.new([ { type: "text", text: "Error: #{str}" } ], error: true)
    end

    class CreateMeetingTool < MCP::Tool
      tool_name "create_meeting"
      description "Creates a meeting for a platform."

      input_schema(
        properties: {
          platform_id: { type: "integer", description: "The platform ID" },
          title:       { type: "string",  description: "Meeting title" },
          starts_at:   { type: "string",  description: "Start time in ISO 8601 format, e.g. '2026-05-01T14:00:00'" },
          ends_at:     { type: "string",  description: "End time in ISO 8601 format (optional)" },
          location:    { type: "string",  description: "Location name or URL (optional)" }
        },
        required: [ "platform_id", "title" ]
      )

      def self.call(platform_id:, title:, starts_at: nil, ends_at: nil, location: nil)
        platform = Platform.find_by(id: platform_id)
        return error("Platform #{platform_id} not found") unless platform

        attrs = {
          title: title,
          starts_at: starts_at ? Time.parse(starts_at) : nil,
          ends_at: ends_at ? Time.parse(ends_at) : nil,
          location: location
        }.compact

        meeting = platform.meetings.build(attrs)
        if meeting.save
          time = meeting.starts_at ? " on #{meeting.starts_at.strftime("%Y-%m-%d %H:%M")}" : ""
          text("Created meeting [#{meeting.id}] \"#{meeting.title}\"#{time}.")
        else
          error(meeting.errors.full_messages.to_sentence)
        end
      rescue ArgumentError => e
        error("Invalid date format: #{e.message}")
      end

      def self.text(str) = MCP::Tool::Response.new([ { type: "text", text: str } ])
      def self.error(str) = MCP::Tool::Response.new([ { type: "text", text: "Error: #{str}" } ], error: true)
    end

    class UpdateMeetingTool < MCP::Tool
      tool_name "update_meeting"
      description "Updates a meeting's title, start time, end time, or location."

      input_schema(
        properties: {
          meeting_id: { type: "integer", description: "The meeting ID" },
          title:      { type: "string",  description: "New title" },
          starts_at:  { type: "string",  description: "New start time in ISO 8601 format" },
          ends_at:    { type: "string",  description: "New end time in ISO 8601 format" },
          location:   { type: "string",  description: "New location" }
        },
        required: [ "meeting_id" ]
      )

      def self.call(meeting_id:, title: nil, starts_at: nil, ends_at: nil, location: nil)
        meeting = Meeting.find_by(id: meeting_id)
        return error("Meeting #{meeting_id} not found") unless meeting

        attrs = {}
        attrs[:title] = title if title
        attrs[:starts_at] = Time.parse(starts_at) if starts_at
        attrs[:ends_at] = Time.parse(ends_at) if ends_at
        attrs[:location] = location unless location.nil?

        if meeting.update(attrs)
          text("Updated meeting [#{meeting.id}] \"#{meeting.title}\".")
        else
          error(meeting.errors.full_messages.to_sentence)
        end
      rescue ArgumentError => e
        error("Invalid date format: #{e.message}")
      end

      def self.text(str) = MCP::Tool::Response.new([ { type: "text", text: str } ])
      def self.error(str) = MCP::Tool::Response.new([ { type: "text", text: "Error: #{str}" } ], error: true)
    end

    class DeleteMeetingTool < MCP::Tool
      tool_name "delete_meeting"
      description "Deletes a meeting."

      input_schema(
        properties: {
          meeting_id: { type: "integer", description: "The meeting ID" }
        },
        required: [ "meeting_id" ]
      )

      def self.call(meeting_id:)
        meeting = Meeting.find_by(id: meeting_id)
        return error("Meeting #{meeting_id} not found") unless meeting

        title = meeting.title
        meeting.destroy!
        text("Deleted meeting \"#{title}\".")
      end

      def self.text(str) = MCP::Tool::Response.new([ { type: "text", text: str } ])
      def self.error(str) = MCP::Tool::Response.new([ { type: "text", text: "Error: #{str}" } ], error: true)
    end
  end
end
