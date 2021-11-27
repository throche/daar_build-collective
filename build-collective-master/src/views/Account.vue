<template lang="html">
  <div class="home" v-if="!account">
    <form @submit.prevent="signUp">
      <card
        title="Enter your username here"
        subtitle="Type directly in the input and hit enter. All spaces will be converted to _"
      >
        <input
          type="text"
          class="input-username"
          v-model="username"
          placeholder="Type your username here"
        />
      </card>
    </form>
  </div>
  <div class="home" v-if="account">
    <div class="card-home-wrapper">
      <card
        :title="account.username"
        :subtitle="`${balance} Ξ\t\t${account.balance} Tokens`"
        :gradient="true"
      >
        <div class="explanations">
          This data has been fetched from the blockchain. You started by
          connecting MetaMask, and you fetched your data by reading the
          blockchain. Try to modify the code to see what's happening!
        </div>
        <div class="explanations">
          On your account on the contract, you have
          {{ account.balance }} tokens. If you click
          <button class="button-link" @click="addTokens">here</button>, you can
          add some token to your account. Just give it a try! And think to put
          an eye on Ganache!
        </div>
      </card>
    </div>

    <div class="card-home-wrapper">
      <card
        :title="account.username"
        :subtitle="`${balance} Ξ\t\t${account.balance} Tokens`"
        :gradient="true"
      >
        <div class="explanations">
          You can now create a project   
          <button class="button-link" @click="createProject">here</button>.             
        </div>
        
      </card>
    </div>
    <div class="card-home-wrapper">
      <card
        :title="account.username"
        :subtitle="`${balance} Ξ\t\t${account.balance} Tokens`"
        :gradient="true"
      >
        <div class="explanations">
          Here is the project list : 
          <button class="button-link" @click="updateProjects">diplay projects</button>.             
           <div class="explanations" v-if="display">

            <div class="explanations" v-for="(p, index) in projects"
              :key="index">
         
                project name : {{p.projectName}}<br>
                creator : {{p.creatorUser}}<br>
                balance : {{p.balance}}<br>
                contributors : {{p.collaborators}}<br>

            </div>  
            </div>  
      
        </div>
      </card>
    </div>
    <div class="card-home-wrapper">
      <card
        :title="account.username"
        :subtitle="`${balance} Ξ\t\t${account.balance} Tokens`"
        :gradient="true"
      >
        <div class="explanations">
          You can fund a project  
          <button class="button-link" @click="fundProject">here</button>.             
        </div>

      </card>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, computed } from 'vue'
import { useStore } from 'vuex'
import Card from '@/components/Card.vue'

export default defineComponent({
  components: { Card },
  setup() {
    const store = useStore()
    const address = computed(() => store.state.account.address)
    const balance = computed(() => store.state.account.balance)
    const contract = computed(() => store.state.contract)
    return { address, contract, balance }
  },
  
  data() {
    const account = null
    const username = ''
    const nbProjects = 0
    const projects = [""]
    const display = false
    return { account, username, nbProjects, projects, display}
  },  
  methods: {

    async updateAccount() {
      const { address, contract } = this
      this.account = await contract.methods.user(address).call()
    },
    async getProjects() {
      const { contract } = this
      let res = new Array(this.nbProjects)
      for (let i = 0; i < this.nbProjects; i++) {       
        res[i] = await contract.methods.project(i).call()
      }
      this.projects = res
    },
    async updateProjects() {
      const { contract } = this
      this.nbProjects = await contract.methods.projectsLength().call()
      this.getProjects()
      this.display = true
    },
    async signUp() {
      const { contract, username } = this
      const name = username.trim().replace(/ /g, '_')
      await contract.methods.signUp(name).send()
      await this.updateAccount()
      this.username = ''
    },
    async addTokens() {
      const { contract } = this
      await contract.methods.addBalance(200).send()
      await this.updateAccount()
    },
    async createProject() {
      const { contract } = this
      await contract.methods.createProject("aaa").send()
      await this.updateProjects()
    },
    async fundProject() {
      const { contract, address } = this
      await contract.methods.addBalanceToProject(200, 0, address).send()
      await this.updateProjects()
      await this.updateAccount()

    },
  },
  async mounted() {
    const { address, contract } = this
    const account = await contract.methods.user(address).call()
    if (account.registered) this.account = account
  },
})
</script>

<style lang="css" scoped>
.home {
  padding: 24px;
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
  max-width: 500px;
  margin: auto;
}

.explanations {
  padding: 12px;
}

.button-link {
  display: inline;
  appearance: none;
  border: none;
  background: none;
  color: inherit;
  text-decoration: underline;
  font-family: inherit;
  font-size: inherit;
  font-weight: inherit;
  padding: 0;
  margin: 0;
  cursor: pointer;
}

.input-username {
  background: transparent;
  border: none;
  padding: 12px;
  outline: none;
  width: 100%;
  color: white;
  font-family: inherit;
  font-size: 1.3rem;
}
</style>
