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
        :subtitle="`${balance} \t\tΞ\t${account.balance} Tokens`"
        :gradient="true"
      >
        <div class="explanations">
          <p>You currently have {{ account.balance }} tokens on your account. Add some tokens to your account here. Enjoy, it's Free!</p>
          <p>Enter here the number of token to receive, then press enter:</p>
          <form @submit.prevent="addTokens">
            <input
            type="text"
            class="input-username"
            v-model="newTokens"
            placeholder="Type amount here"
            />
          </form>
        </div>
      </card> 
    </div>

    <div class="card-home-wrapper">
      <card
        :title="'Create a new project'"
        :subtitle="'Take the lead !'"
        :gradient="true"
        :blue="true"
      >
        <div class="explanations">
          <p>
          Create a new project by entering its name below then pressing enter. The project will be listed among the other projects. Every project has a balance account which contributors can fund.</p>
          <form @submit.prevent="createProject">
            <input
            type="text"
            class="input-username"
            v-model="project_name"
            placeholder="Type the project name here"
            />
          </form>
        </div>
        
      </card>
    </div>
    <div class="card-home-wrapper">
      <card
        :title="'List all projects'"
        :subtitle="'Get inspired !'"
        :gradient="true"
        :blue="true"
      >
        <div class="explanations">
          
          <button class="button-link" @click="updateProjects">Refresh project list here</button>             
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
        :title="'Fund a project'"
        :subtitle="`Become a collaborator ! \t\tΞ\t${account.balance} Tokens`"
        :gradient="true"
        :blue="true"
      >
        <div class="explanations">
          <p>Enter the name of the project which you want to add funds and the amount.</p>
          <p>By adding tokens to the project, you will become a contributor.</p>
          <input
          type="text"
          class="input-username"
          v-model="project_name"
          placeholder="Type exact project name"
          />
          <input
          type="text"
          class="input-username"
          v-model="donation"
          placeholder="Type amount here"
          />
          <button class="button-link" @click="fundProject">Confirm</button>         
        </div>

      </card>
    </div>
    <div class="card-home-wrapper">
      <card
        :title="'Allocate budget from your project'"
        :subtitle="`It's payday !`"
        :gradient="true"
        :blue="true"
      >
        <div class="explanations">
          <p>Project creator can transfer tokens to collaborators only.</p>
          <p>Enter the name of the project which you want to transfer funds from and the amount.</p>
          <input
          type="text"
          class="input-username"
          v-model="project_name"
          placeholder="Type exact project name"
          />
          <input
          type="text"
          class="input-username"
          v-model="addrReceiver"
          placeholder="Type collaborator address here (starts with 0x)"
          />
          <input
          type="text"
          class="input-username"
          v-model="budget"
          placeholder="Type amount here"
          />
          <button class="button-link" @click="allocateProjectBudget">Confirm</button>         
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
    const project_name = ''
    const nbProjects = 0
    const projects = [""]
    const display = false
    const newTokens = 0
    const donation = 0
    const budget = 0
    const addrReceiver = ''
    return { account, username, project_name, nbProjects, projects, display, newTokens, donation, budget, addrReceiver}
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
      const { contract, newTokens } = this
      await contract.methods.addBalance(newTokens).send()
      await this.updateAccount()
      this.newTokens = 0
    },
    async createProject() {
      const { contract, project_name } = this
      await contract.methods.createProject(project_name).send()
      await this.updateProjects()
      this.project_name = ''
    },
    async fundProject() {
      const { contract, project_name, donation} = this
      await contract.methods.addBalanceToProject(donation, project_name).send()
      await this.updateProjects()
      await this.updateAccount()
      this.project_name = ''
      this.donation = 0
    },
    async allocateProjectBudget() {
      const { contract, addrReceiver, project_name, budget} = this
      await contract.methods.allocateProjectBudget(budget, project_name, addrReceiver).send()
      await this.updateProjects()
      await this.updateAccount()
      this.project_name = ''
      this.budget = 0
      this.addrReceiver = ''
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
