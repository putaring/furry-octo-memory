require 'rails_helper'

feature "Conversations" do
  let(:recipient) { create(:recipient) }
  let(:sender)    { create(:sender) }
  describe "Sending a message from the profile page" do
    context "Logged out" do
      it "should not give the user an option to send a message to the recipient" do
        visit user_path(recipient)
        expect(page).to_not have_content('Message')
      end
    end

    context "Logged in" do
      background do
        visit login_path
        login(sender)
      end

      it "should give the user an option to send a message to the recipient" do
        visit user_path(recipient)
        within('.jumbotron') { expect(page).to have_content('Message') }
      end

      context "sending a message" do
        it "should allow the user to send a valid message" do
          visit user_path(recipient)
          within('#message-modal') do
            fill_in 'message_body', with: Faker::Lorem.characters(1000)
            click_button 'Send'
            expect(Message.count).to eq(1)
            expect(sender.sent_messages.count).to eq(1)
            expect(recipient.received_messages.count).to eq(1)
            expect(recipient.sent_messages.count).to eq(0)
            expect(sender.received_messages.count).to eq(0)
          end
        end

        it "shouldn't allow the user to send a huge message" do
          visit user_path(recipient)
          within('#message-modal') do
            fill_in 'message_body', with: Faker::Lorem.characters(1001)
            expect { click_button 'Send' }.to change(Message, :count).by(0)
          end
        end

        it "shouldn't allow the user to send an empty message" do
          visit user_path(recipient)
          within('#message-modal') do
            fill_in 'message_body', with: ''
            expect { click_button 'Send' }.to change(Message, :count).by(0)
          end
        end
      end

      it "should not give the user an option to send a message when they're on their own profile page" do
        visit user_path(sender)
        within('.jumbotron') { expect(page).to_not have_content('Message') }
      end

    end
  end
end
