//
//  FixedAsteroidField.swift
//  spaceships
//
//  Created by Jonathan Salin Lee on 3/30/17.
//  Copyright © 2017 Salin Studios. All rights reserved.
//

import Foundation
import SpriteKit

class FixedAsteroidField: SKNode {
    var rockfield = [Asteroid(x: 1929.0, y: 1786.0, z: 2.49106168746948),
    Asteroid(x: 906.0, y: 1548.0, z: 5.28092527389526),
    Asteroid(x: 1549.0, y: 910.0, z: 2.22007608413696),
    Asteroid(x: 1882.0, y: 1522.0, z: 2.8059663772583),
    Asteroid(x: 1048.0, y: 927.0, z: 2.00240564346313),
    Asteroid(x: 1103.0, y: 858.0, z: 5.56959390640259),
    Asteroid(x: 1278.0, y: 76.0, z: 0.0979099273681641),
    Asteroid(x: 1440.0, y: 486.0, z: 3.66994714736938),
    Asteroid(x: 279.0, y: 939.0, z: 1.00134265422821),
    Asteroid(x: 817.0, y: 75.0, z: 2.41095805168152),
    Asteroid(x: 1511.0, y: 737.0, z: 4.34170866012573),
    Asteroid(x: 318.0, y: 908.0, z: 0.369821459054947),
    Asteroid(x: 289.0, y: 1755.0, z: 5.6539511680603),
    Asteroid(x: 824.0, y: 730.0, z: 1.02758955955505),
    Asteroid(x: 445.0, y: 643.0, z: 0.999475717544556),
    Asteroid(x: 313.0, y: 1132.0, z: 3.34934449195862),
    Asteroid(x: 1277.0, y: 1216.0, z: 3.79594993591309),
    Asteroid(x: 612.0, y: 1101.0, z: 3.66120600700378),
    Asteroid(x: 822.0, y: 694.0, z: 1.69627857208252),
    Asteroid(x: 1568.0, y: 501.0, z: 2.45344686508179),
    Asteroid(x: 1168.0, y: 1025.0, z: 1.84349012374878),
    Asteroid(x: 616.0, y: 1540.0, z: 4.66449499130249),
    Asteroid(x: 1647.0, y: 1033.0, z: 1.87569165229797),
    Asteroid(x: 433.0, y: 1354.0, z: 0.474619746208191),
    Asteroid(x: 1333.0, y: 1631.0, z: 2.54458093643188),
    Asteroid(x: 1109.0, y: 860.0, z: 5.3870644569397),
    Asteroid(x: 1362.0, y: 353.0, z: 5.91856145858765),
    Asteroid(x: 1065.0, y: 1230.0, z: 4.1646876335144),
    Asteroid(x: 460.0, y: 574.0, z: 5.31856441497803),
    Asteroid(x: 543.0, y: 1012.0, z: 0.0173106864094734),
    Asteroid(x: 1878.0, y: 1023.0, z: 2.90521454811096),
    Asteroid(x: 599.0, y: 1590.0, z: 3.34639954566956),
    Asteroid(x: 760.0, y: 1164.0, z: 4.95037460327148),
    Asteroid(x: 1270.0, y: 1281.0, z: 1.66889083385468),
    Asteroid(x: 1134.0, y: 953.0, z: 6.17481470108032),
    Asteroid(x: 1153.0, y: 1742.0, z: 1.92758786678314),
    Asteroid(x: 395.0, y: 462.0, z: 3.77528405189514),
    Asteroid(x: 701.0, y: 584.0, z: 3.82467317581177),
    Asteroid(x: 1879.0, y: 1017.0, z: 1.33479237556458),
    Asteroid(x: 1159.0, y: 820.0, z: 5.56624317169189),
    Asteroid(x: 600.0, y: 1429.0, z: 1.91421699523926),
    Asteroid(x: 1008.0, y: 1251.0, z: 0.954163670539856),
    Asteroid(x: 1500.0, y: 1722.0, z: 2.1215922832489),
    Asteroid(x: 935.0, y: 1680.0, z: 2.43458938598633),
    Asteroid(x: 1517.0, y: 379.0, z: 4.04392004013062),
    Asteroid(x: 778.0, y: 446.0, z: 4.7347149848938),
    Asteroid(x: 1784.0, y: 947.0, z: 3.79263186454773),
    Asteroid(x: 1115.0, y: 1517.0, z: 3.34031891822815),
    Asteroid(x: 1666.0, y: 1704.0, z: 2.88624596595764),
    Asteroid(x: 1186.0, y: 837.0, z: 4.09970569610596)]
    func spawn(scene:GameScene) {
        for i in self.rockfield {
            scene.addChild(i)
        }
    }
}
