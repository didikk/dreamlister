//
//  ItemDetailVC.swift
//  DreamLister
//
//  Created by Didik Ismawanto on 2/23/17.
//  Copyright © 2017 Didik Ismawanto. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var detailField: UITextField!
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var imageThumb: UIImageView!
    
    var stores = [Store]()
    var itemToEdit: Item?
    var imagePicker: UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        storePicker.delegate = self
        storePicker.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        //generateStoreData()
        getStores()
        
        if itemToEdit != nil {
            loadItemData()
        }
        
    }
    
    func generateStoreData(){
        let store = Store(context: context)
        store.name = "Apple Store"
        
        let store2 = Store(context: context)
        store2.name = "Amazon"
        
        let store3 = Store(context: context)
        store3.name = "Lazada"
        
        let store4 = Store(context: context)
        store4.name = "Tokopedia"
        
        let store5 = Store(context: context)
        store5.name = "Olx"
        
        let store6 = Store(context: context)
        store6.name = "Hi-Tech Mall"
        
        ad.saveContext()
    }
    
    @IBAction func savePressed(_ sender: Any) {
        var item: Item
        let picture = Image(context: context)
        picture.image = imageThumb.image
        
        if itemToEdit == nil {
            item = Item(context: context)
        } else {
            item = itemToEdit!
        }
        
        item.toImage = picture
        
        
        item.created = NSDate()
        if let title = titleField.text {
            item.title = title
        }
        
        if let price = priceField.text {
            item.price = (price as NSString).doubleValue
        }
        
        if let detail = detailField.text {
            item.detail = detail
        }
        
        ad.saveContext()
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        backToMainScreen()
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return stores[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }

    func getStores(){
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        do {
            stores = try context.fetch(fetchRequest)
            
            if stores.count == 0 {
                generateStoreData()
                stores = try context.fetch(fetchRequest)
            }
            storePicker.reloadAllComponents()
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func loadItemData(){
        if let item = itemToEdit {
            titleField.text = item.title
            priceField.text = "\(item.price)"
            detailField.text = item.detail
            imageThumb.image = item.toImage?.image as? UIImage
            
            if let store = item.toStore {
                for i in 0..<stores.count {
                    let currentStore = stores[i]
                    if currentStore.name == store.name {
                        storePicker.selectRow(i, inComponent: 0, animated: false)
                        break
                    }
                }
            }
        }
    }

    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        if itemToEdit != nil {
            context.delete(itemToEdit!)
            ad.saveContext()
            
            backToMainScreen()
        }
    }
    
    func backToMainScreen(){
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pickImagePressed(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageThumb.image = img
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
}
