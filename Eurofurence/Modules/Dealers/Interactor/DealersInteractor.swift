import Foundation

protocol DealersInteractor {

    func makeDealersViewModel(completionHandler: @escaping (DealersViewModel) -> Void)
    func makeDealersSearchViewModel(completionHandler: @escaping (DealersSearchViewModel) -> Void)
    func makeDealerCategoriesViewModel(completionHandler: @escaping (DealerCategoriesViewModel) -> Void)

}
