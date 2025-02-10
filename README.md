# Codename: Twine

A simple, free, open-source system to manage your business, group or organisation -- whether you're incorporated or not.

## Inquiries?

This project is maintained by Tomas! Reach out to me on hey@twine.no

## How to get the project up and running

Proper instructions will come later, but it's a Ruby on Rails project, so install Ruby, Rails, run bundle, migrate DB
etc.

## Contribute

Feel free to explore the code and submit pull requests. It's early days, and proper processes will be formalised.
It's a good idea to reach out to Tomas first if you have a bigger idea you want to add to the project.

## License

Protected under the JGTHF (Just Give Tomas a Heads-up First) license, in case you want to use the code
for something radically different from the scope of this app/project.

## Code

### Turbo & Modals

It's not completely straight forward to make modals work with Turbo. 

When you want to open a page inside a modal, use the `modal_link_to` method instead of `link_to`
(with tables, you can use `modal_row_link_to` instead of `row_link_to`).

``` 
modal_link_to("Edit group", edit_admin_group_path(@group), class: "button button-secondary")
``` 

Inside the modal, render the content inside a `modal_content` Turbo frame, and specify the content inside
inside a `modal_content` block to apply the standard modal styles.

``` 
# i.e. views/admin/groups/edit.html.erb
<%= turbo_frame_tag :modal_content do %>
  <%= modal_content do %>
    Put your content here.
  <% end %>
<% end %>
``` 

If you want a form inside the modal to close the modal on form submission,
you need to specify the following data tags to ensure the HTML modal dialogue 
doesn't prevent the page from becoming interactive.
``` 
# i.e. views/admin/groups/_form.html.erb
data: {
    turbo_frame: "_top",
    action: "turbo:submit-end->modal#close"
}

# Or for a button_to element
data: {
  turbo_frame: "_top",
},
form: {
  data: {
    action: "turbo:submit-end->modal#close",
  }
}
```

Then simply redirect to the desired page from the controller

``` 
# controllers/admin/groups/groups_controller.rb
redirect_to admin_memberships_path(tab: @group.id), notice: "#{@group.name} updated."
}
```