//
//  RMSettingsView.swift
//  RickMorty
//
//  Created by Dino Pelic on 21. 2. 2023..
//

import SwiftUI

struct RMSettingsView: View {
    let viewModel: RMSettingsViewViewModel
    
    init(viewModel: RMSettingsViewViewModel) {
        self.viewModel = viewModel
    }
        
    var body: some View {
        List(viewModel.cellViewModels) { vm in
            HStack {
                if let image = vm.image {
                    Image(uiImage: image)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color.white)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .padding(8)
                        .background(Color(vm.itemContainerColor))
                        .cornerRadius(6)
                }
                Text(vm.title)
                    .padding(.leading, 10)
            }
            .padding(.bottom, 2)
        }
    }
}

struct RMSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        RMSettingsView(viewModel: RMSettingsViewViewModel(cellViewModels: RMSettingsOption.allCases.compactMap({ RMSettingsCellViewModel(type: $0) })))
    }
}
