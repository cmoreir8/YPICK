//
//  RatingViewModel.swift
//  YPick
//
//  Created by Chris Moreira on 11/22/23.
//

//
//  HomeViewModel.swift
//  Foodee
//
//  Created by Chris Moreira on 11/21/23.
//

import Foundation
import Combine
import MapKit

final class RatingViewModel: ObservableObject{
    
    @Published var businesses = [Business]()
    @Published var winnerResult = ""
    @Published var winnerCoordinates = CLLocationCoordinate2D()
    
    func search(){
        let live = YelpApiService.live
        
        live.search(winnerResult, winnerCoordinates, nil)
            .assign(to: &$businesses)
    }
}

