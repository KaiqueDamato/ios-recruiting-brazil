//
//  PosterViewSpec.swift
//  ConcreteChallengeTests
//
//  Created by Kaique Damato on 10/1/20.
//  Copyright © 2020 KiQ. All rights reserved.
//

import Quick
import Nimble
import Nimble_Snapshots
@testable import ConcreteChallenge

class PosterViewSpec: QuickSpec {
    
    override func spec() {
    
        let movieCollection = MovieColletion(serviceLayer: ServiceLayerMock())
        
        describe("set up view") {
            
            beforeSuite {
                movieCollection.requestMovies()
            }
            
            it("with basic layout") {
                let movie = movieCollection.movie(at: 0)!
                movie.coreDataHelper = CoreDataHelperMock()
                
                let posterView = PosterView(for: movie)
                posterView.frame = UIScreen.main.bounds
                posterView.imageView.image = UIImage(named: "testImage")
                
                expect(posterView).toEventually( haveValidSnapshot() )
            }
            
            it("with favorite layout") {
                let movie = movieCollection.movie(at: 1)!
                movie.coreDataHelper = CoreDataHelperMock()
                
                let posterView = PosterView(for: movie)
                posterView.frame = UIScreen.main.bounds
                posterView.imageView.image = UIImage(named: "testImage")
                
                expect(posterView).toEventually( haveValidSnapshot() )
            }
        }
    }
}
