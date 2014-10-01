$(function() {
 
  $( document ).tooltip();
  

  $('.admin_monitor_alerts_to_issue').bind('ajax:success',function(event, data, status, xhr){
    if(status == 'success'){
      imag_obj = $("#admin_monitor_alerts_to_issue_" + data["response"][0] + " img")
      imag_obj.attr("src", '../plugin_assets/redmine_admin_monitor/images/duplicate.png');
      imag_obj.attr("title", 'Go to Issue!');

      a_link = imag_obj.parent();
      a_link.attr("href", "/issues/" + data["response"][1]);
      a_link.removeAttr("data-remote")

      link = imag_obj.parent().parent().parent().find("td.issue_id_holder");
      jQuery('<a/>', {
       href: "/issues/" + data["response"][1],
       text: data["response"][1]
     }).appendTo(link);

    }else{
     alert(data["response"][0]);
   }   
 });

  $('.admin_monitor_alerts_handle_flag').bind('ajax:success',function(event, data, status, xhr){
    if(status == 'success'){
      imag_obj = $("#admin_monitor_alerts_handle_flag_" + data["response"][0] + " img")
      image = (data["response"][1]) ? "false" : "true"
      imag_obj.attr("src", '../plugin_assets/redmine_admin_monitor/images/' + image + '.png');
      title = (data["response"][1]) ? "UnHandle!" : "Handle!"
      imag_obj.attr("title", title );

      link = imag_obj.parent();
      link.attr("href", link.attr("href").replace(data["response"][1],image));

    }else{
      alert(data["response"][0]);
    }   
  });

  $('.admin_monitor_alerts_silent_flag').bind('ajax:success',function(event, data, status, xhr){
    if(status == 'success'){
      imag_obj = $("#admin_monitor_alerts_silent_flag_" + data["response"][0] + " img")
      image = (data["response"][1]) ? "silent" : "unsilent";
      imag_obj.attr("src", '../plugin_assets/redmine_admin_monitor/images/' + image + '.png');
      title = (data["response"][1]) ? "Click to disable mail alert for this error" : "Click to enable mail alert for this error" ;
      imag_obj.attr("title", title );

      link = imag_obj.parent();
      link.attr("href", link.attr("href").replace(data["response"][1],!data["response"][1]));

    }else{
      alert(data["response"][0]);
    }   
  });

});
