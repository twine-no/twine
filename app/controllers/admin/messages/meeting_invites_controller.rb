module Admin
  module Messages
    class MeetingInvitesController < AdminController
      before_action :set_meeting, only: [:new, :create]
      before_action :redirect_back_to_meeting_page, unless: :turbo_frame_request?, only: :new

      def new
        @message = @meeting.messages.new
      end

      def create
        messages = @meeting.invites.not_messaged.map do |invite|
          invite.messages.new(message_params.merge(category: :email))
        end

        Message.transaction do
          messages.each(&:save!)
        end

        messages.each { |message| message.deliver!(mailer: InvitesMailer.invite(message)) }
        redirect_to admin_meeting_path(@meeting), notice: "Invitation sent!"
      end

      private

      def set_meeting
        @meeting = Current.platform.meetings.find(params[:meeting_id])
      end

      def redirect_back_to_meeting_page
        redirect_to admin_meeting_path(@meeting)
      end

      def message_params
        params.require(:message).permit(:content)
      end
    end
  end
end