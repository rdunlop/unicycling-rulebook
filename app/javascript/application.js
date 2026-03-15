import Rails from "@rails/ujs";
import $ from "jquery";
import moment from "moment";
import select2 from "select2";
import "foundation-sites";

// Make jQuery global — Foundation, Select2, and legacy code expect window.$
window.$ = window.jQuery = $;
window.moment = moment;

// Initialize Rails UJS (replaces jquery_ujs — handles data-method and data-confirm)
Rails.start();

// Register Select2 as a jQuery plugin (esbuild bundles it as a factory in CommonJS mode)
if (typeof select2 === 'function') { select2(window, $); }

// Initialize Foundation
$(function() { $(document).foundation(); });

// Initialize Select2
$(function() {
  $(".chosen-select").select2({ placeholder: "Select an Option" });
});

// Moment.js relative timestamps
document.addEventListener("DOMContentLoaded", function() {
  document.querySelectorAll('.js--days-ago').forEach(function(elem) {
    elem.textContent = moment(elem.getAttribute('datetime')).fromNow();
  });
});

// Toggle behavior (originally toggle.js.coffee)
function toggle() {
  function toggleItem(el) {
    var target = $(el).data('toggle');
    $(target).toggle().toggleClass('is--hidden is--visible');
    $(el).toggleClass('is--toggled').blur();
  }
  $("body").on("click", ".js--toggle", function() {
    toggleItem(this);
    $("html, body").animate({ scrollTop: $(this).offset().top - 10 }, 1000);
  });
  var inactive_parent = $(".js--collapsible .is--active")
    .closest('.is--hidden').removeClass('is--hidden').addClass('is--visible');
  inactive_parent.siblings('span').addClass('is--toggled');
  inactive_parent.closest('.navSection__item').addClass('is--toggled');
}
$(document).ready(toggle);

import "./tinymce_init";
import "./revisions";
