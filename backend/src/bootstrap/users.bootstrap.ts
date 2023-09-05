import { UserModel } from '../models/users.model'
import { Bootstrapper } from './Bootstraper'
import { v4 as uuidv4 } from 'uuid'


export default class UserBootstrap extends Bootstrapper {
  async run() {
    UserModel.bulkCreate([
      {
        userId: uuidv4(),
        roleId: 1,
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@example.com',
        phoneNumber: '1234567890',
        age: 30,
        state: 'NY',
        sex: 'masculine',
      },
      {
        userId: uuidv4(),
        roleId: 2,
        firstName: 'Jane',
        lastName: 'Doe',
        email: 'jane.doe@example.com',
        phoneNumber: '0987654321',
        age: 25,
        state: 'CA',
        sex: 'femenine',
      },
    ])
  }
}
