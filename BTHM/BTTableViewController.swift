//
//  BTTableViewController.swift
//  BTHM
//
//  Created by Alexander v. Below on 14.11.16.
//  Copyright © 2016 Alexander von Below. All rights reserved.
//

import UIKit
import CoreBluetooth

class BTTableViewController: UITableViewController, CBCentralManagerDelegate {

    var btManager : CBCentralManager!
    var devices : [CBPeripheral] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.btManager = CBCentralManager.init(delegate: self, queue: nil)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOff:
            print ("poweredOff")
        case .poweredOn:
            print ("poweredOn")
            self.btManager.scanForPeripherals(withServices: nil, options: nil)
        case .resetting:
            print ("resetting")
        case .unauthorized:
            print ("unauthorized")
        case .unknown:
            print ("unknown")
        case .unsupported:
            print ("unsupported")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print ("New Device\n\(peripheral.name), \(RSSI)")
        if !devices.contains(peripheral) {
            devices.append(peripheral)
            self.tableView.reloadData()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        self.performSegue(withIdentifier: "Services", sender: self)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return devices.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)

        cell.textLabel?.text = devices[indexPath.row].name
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let device = devices[indexPath.row]
        
        switch device.state {
        case .connected:
            self.performSegue(withIdentifier: "Services", sender: self)
        case .disconnected:
            btManager.connect(device, options: nil)
        case .disconnecting, .connecting:
            break
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Services", let servicesController = segue.destination as? ServicesTableViewController, let indexPath = self.tableView.indexPathForSelectedRow {
            servicesController.device = devices[indexPath.row]
        }
    }
}
