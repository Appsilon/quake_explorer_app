describe('Checking absence of markers for Explosions with maximum magnitude', () => {
    
    // Declaring vals
    const sliderValues = [1, 2, 3, 4, 5, 6];
    const quakeTypes = ['earthquake', 'explosion', 'quarry blast', 'ice quake']

    // Declaring vals for slider movement
    const rightarrows = '{rightarrow}'.repeat(1);
    const leftarrows = '{leftarrow}'.repeat(3);

    it('confirms that marker should not be there for maximum magnitude of Explosion', () => {
      cy.visit('/')

      // Declaring Selectors
        // slider
      cy.get('div#sidebar').find('div.react-container').eq(0)
        .find('div.ms-Slider-container')
        .find('div.ms-Slider-slideBox')
        .focus()
        .as('sliderarea')
        // checkbox
      cy.get('div.shiny-options-group')
        .first()
        .find('label.checkbox-inline')
        .as('checkbox_group')
        // leaflet leaflet
      cy.get('div.leaflet-overlay-pane')
        .find('svg.leaflet-zoom-animated')
        .as('leaflet_markers')
       
      // Setting slider to 1  
      cy.get('@sliderarea')
        .type(rightarrows)
        .type(rightarrows);
      cy.wait(2000)

      // Checking 2nd choice only
      cy.get('@checkbox_group').eq(0).click()
      cy.get('@checkbox_group').eq(1).click()

      cy.get('@leaflet_markers')
        .should('not.exist')
        //.should('have.length.at.least', 1)

  })
})
