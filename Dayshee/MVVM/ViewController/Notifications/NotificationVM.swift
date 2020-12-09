//
//  NotificationVM.swift
//  Dayshee
//
//  Created by paxcreation on 12/9/20.
//  Copyright © 2020 ThanhPham. All rights reserved.
//

import RxCocoa
import RxSwift

class ListNotificationVM: ActivityTrackingProgressProtocol {
    @Replay(queue: MainScheduler.asyncInstance) var err: ErrorService
    @Replay(queue: MainScheduler.asyncInstance) var listNotification: ListNotificationModel
    @Replay(queue: MainScheduler.asyncInstance) var listNotificationCallBack: ListNotificationModel
    private let disposeBag = DisposeBag()
    func getlistNotification(page: Int) ->  Observable<ApiResult<OptionalMessageDTO<ListNotificationModel>, ErrorService>>  {
        let url = "/user/notification?page=\(page)&per_page=10"
       return RequestService.shared.APIData(ofType: OptionalMessageDTO<ListNotificationModel>.self,
                                      url: url,
                                      parameters: nil,
                                      method: .get)
            .trackProgressActivity(self.indicator)
            .map { (result) in
                return result
            }
    }
    func getlistNotificationCallBack() {
        let url = "/user/notification?page=1&per_page=10"
        RequestService.shared.APIData(ofType: OptionalMessageDTO<ListNotificationModel>.self,
                                      url: url,
                                      parameters: nil,
                                      method: .get)
            .trackProgressActivity(self.indicator)
            .bind { (result) in
                switch result {
                case .success(let value):
                    guard let data = value.data, let model = data else {
                        return
                    }
                    self.listNotificationCallBack = model
                case .failure(let err):
                    self.err = err
                }}.disposed(by: disposeBag)
    }
}
