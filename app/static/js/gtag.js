
$(() => {

  /* Default installation */

  window.dataLayer = window.dataLayer || [];
  function gtag() {
    dataLayer.push(arguments);
  };
  gtag('js', new Date());
  gtag('config', 'G-FQQZL5V93G');


  // Send event when Dark Mode is toggled

  $('#app-btn_tog').on('click', (event) => {
  if ($("#app-btn_tog").hasClass('pill-66')) {
    gtag('event', 'dark_mode_toggled', { dark_mode: 'On'});
  } else {
    gtag('event', 'dark_mode_toggled', { dark_mode: 'Off'});
  }
  });
  
  // Send event when Info Button is clicked
  
  $('#cta_info').on('click', (event) => {
  gtag('event', 'info_modal_clicked')
  });
  
  // Send event when Let's Talk Button is clicked
  
  $('#cta_talk').on('click', (event) => {
  gtag('event', 'lets_talk_button_clicked')
  });

});