
RecodeLandClass <- function(lcd_original){
    rcl <- matrix(nrow=20, ncol=2)
    rcl[, 1] <- c(11, 12,          # 11: open water, 12: perennial ice/snow
                21, 22, 23, 24,    # developed -- 21: open (single family housing, golf courses, etc.), 22: low, 23: medium and 24: high intensity
                31,                # barren rock, sand, clay
                41, 42, 43,        # 41: deciduous, 42: evergreen, and 43: mixed forest
                51, 52,            # 51: dwarf scrib (Alaska only), 52: shrub
                71, 72, 73, 74,    # 71: grassland, 72: sedge/herbaceous (alaska only); 73: lichens (alaska only); 74: moss (alaska only)
                81, 82,            # 81: pasture, 82: crops
                90, 95)            # 90: woody wetlands, 95: emergent herbaceous wetlands
    rcl[, 2] <- c(11, 11,          # -> water
                21, 21, 21, 21,    # -> developed
                31,                # -> barren
                41, 41, 41,        # -> forest
                52, 52,            # -> shrub/scrub
                71, 71, 71, 71,    # -> grassland
                81, 81,            # -> pasture/cultivated
                90, 95)            # no change
    lcd <- terra::classify(lcd_original, rcl)
    return(lcd)
}
