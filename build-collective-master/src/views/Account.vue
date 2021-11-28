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

    <!-- --- CARDS : PROJECTS --- -->

    <div class="card-home-wrapper">
      <card
        :title="'Create a new project'"
        :subtitle="'Take the lead !'"
        :gradient="true"
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
      >
        <div class="explanations">
          <button class="button-link" @click="updateProjects">Refresh project list here</button>
           <div class="explanations" v-if="display">
            <div class="explanations" v-for="(p, index) in projects"
              :key="index">
         
                Project name : {{p.projectName}}<br>
                <div v-if="p.creatorType == 0">Creator (user) : {{p.creatorUser}}<br></div>
                <div v-else>Creator (company) : {{p.creatorEntreprise}}<br></div>
                Balance : {{p.balance}}<br>
                Company Contributors : {{p.collaboratorsEntreprise}}<br>
                Private Contributors : {{p.collaborators}}<br>

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
          placeholder="Type collaborator address here: 0x..."
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

    <!-- --- CARDS : ENTERPRISES --- -->

    <div class="card-home-wrapper">
      <card
        :title="'Create an enterprise'"
        :subtitle="'CEOs, we need you !'"
        :gradient="true"
        :blue="true"
      >
        <div class="explanations">
          <p>
          Create a new enterprise by entering its name below then pressing enter. Every company has a balance account which members can fund and the CEO can allocate.</p>
          <form @submit.prevent="createEntreprise">
            <input
            type="text"
            class="input-username"
            v-model="enterpriseName"
            placeholder="Type the enterprise name here"
            />
          </form>
        </div>
      </card>
    </div>

    <div class="card-home-wrapper">
      <card
        :title="'List current companies'"
        :subtitle="'See who is ahead !'"
        :gradient="true"
        :blue="true"
      >
        <div class="explanations">
          <button class="button-link" @click="updateEnterprises">Refresh enterprise list here</button>
           <div class="explanations" v-if="display">
            <div class="explanations" v-for="(e, index) in enterprises"
              :key="index">
         
                entreprise name : {{e.name}}<br>
                ceo : {{e.owner}}<br>
                balance : {{e.balance}}<br>
                members : {{e.members}}<br>

            </div>  
            </div>  
        </div>
      </card>
    </div>

    <div class="card-home-wrapper">
      <card
        :title="'Join your enterprise'"
        :subtitle="'Employees join their business here'"
        :gradient="true"
        :blue="true"
      >
        <div class="explanations">
          <p>Enter the name of your enterprise and press enter to join it.</p>
          <form @submit.prevent="joinEntreprise">
            <input
            type="text"
            class="input-username"
            v-model="enterpriseName"
            placeholder="Type the enterprise name here"
            />
          </form>
        </div>
      </card>
    </div>

    <div class="card-home-wrapper">
      <card
        :title="'Enterprise : add balance'"
        :subtitle="`All members can fund their business.`"
        :gradient="true"
        :blue="true"
      >
        <div class="explanations">
          <p>Enter the name of the enterprise which you want to add funds and the amount.</p>
          <input
          type="text"
          class="input-username"
          v-model="enterpriseName"
          placeholder="Type exact enterprise name"
          />
          <input
          type="text"
          class="input-username"
          v-model="donation"
          placeholder="Type amount here"
          />
          <button class="button-link" @click="addBalanceToEntreprise">Confirm</button>         
        </div>
      </card>
    </div>

    <div class="card-home-wrapper">
      <card
        :title="'Enterprise: Create a project'"
        :subtitle="`CEOs can create projects`"
        :gradient="true"
        :blue="true"
      >
        <div class="explanations">
          <p>Enter the name of the enterprise name and the project name.</p>
          <input
          type="text"
          class="input-username"
          v-model="enterpriseName"
          placeholder="Type the enterprise name here"
          />
          <input
          type="text"
          class="input-username"
          v-model="project_name"
          placeholder="Type the project name here"
          />
          <button class="button-link" @click="createProjectEntreprise">Confirm</button>         
        </div>
      </card>
    </div>

    <div class="card-home-wrapper">
      <card
        :title="'Enterprise : Fund a project'"
        :subtitle="`Enlist your company as a collaborator !`"
        :gradient="true"
        :blue="true"
      >
        <div class="explanations">
          <p>Enter the name of your company, the project which you want to add funds and the amount.</p>
          <p>By adding tokens to the project, your company becomes a contributor.</p>
          <input
          type="text"
          class="input-username"
          v-model="enterpriseName"
          placeholder="Type your enterprise name"
          />
          <input
          type="text"
          class="input-username"
          v-model="project_name"
          placeholder="Type the exact project name"
          />
          <input
          type="text"
          class="input-username"
          v-model="donation"
          placeholder="Type amount here"
          />
          <button class="button-link" @click="addBalanceToProjectUsingEntreprise">Confirm</button>         
        </div>
      </card>
    </div>

    <!-- --- CARDS : BOUNTIES --- -->

    <div class="card-home-wrapper">
      <card
        :title="'Bounty : Create a new bounty'"
        :subtitle="`Let the hunt begin !`"
        :gradient="true"
        :blue="false"
      >
        <div class="explanations">
          <p>Enter the name of your project, the description of the issue and the reward amount.</p>
          <p>You must be the project leader to make a new bounty.</p>
          <p>The necessary funds must be available for the reward.</p>
          <input
          type="text"
          class="input-username"
          v-model="project_name"
          placeholder="Type your project name"
          />
          <input
          type="text"
          class="input-username"
          v-model="budget"
          placeholder="Type reward amount"
          />
          <input
          type="text"
          class="input-username"
          v-model="bountyDescription"
          placeholder="Type in the bug description"
          />
          <button class="button-link" @click="createBounty">Confirm</button>         
        </div>
      </card>
    </div>

    <div class="card-home-wrapper">
      <card
        :title="'Bounty : Solve a bounty'"
        :subtitle="`The american dream !\tΞ\t${account.balance} Tokens`"
        :gradient="true"
        :blue="false"
      >
        <div class="explanations">
          <p>Enter the name of the project's bounty, the bounty ID to identify it and the bug correction to collect your reward.</p>
          <p>The necessary funds must be available for the reward.</p>
          <input
          type="text"
          class="input-username"
          v-model="project_name"
          placeholder="Type the project name"
          />
          <input
          type="text"
          class="input-username"
          v-model="bountyID"
          placeholder="Type the bounty ID #"
          />
          <input
          type="text"
          class="input-username"
          v-model="bountyCorrection"
          placeholder="Type in the bug correction"
          />
          <button class="button-link" @click="solveBounty">Confirm</button>         
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
    const nbEnterprises = 0
    const projects = [""]
    const enterprises = [""]
    const display = false
    const newTokens = 0
    const donation = 0
    const budget = 0
    const addrReceiver = ''
    const enterpriseName = ''
    const bountyDescription = ''
    const bountyCorrection = ''
    const bountyID = 0
    return { account, username, project_name, nbProjects, nbEnterprises, projects, enterprises, display, newTokens, donation, budget, addrReceiver, enterpriseName, bountyDescription, bountyCorrection, bountyID}
  },  
  methods: {

    async updateAccount() {
      const { address, contract } = this
      this.account = await contract.methods.user(address).call()
    },
    async getEnterprises() {
      const { contract } = this
      let res = new Array(this.nbEnterprises)
      for (let i = 0; i < this.nbEnterprises; i++) {       
        res[i] = await contract.methods.entreprise(i).call()
      }
      this.enterprises = res
    },
    async updateEnterprises() {
      const { contract } = this
      this.nbEnterprises = await contract.methods.entreprisesLength().call()
      this.getEnterprises()
      this.display = true
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
    async createEntreprise() {
      const { contract, enterpriseName } = this
      await contract.methods.createEntreprise(enterpriseName).send()
      this.enterpriseName = ''
    },
    async joinEntreprise() {
      const { contract, enterpriseName } = this
      await contract.methods.joinEntreprise(enterpriseName).send()
      await this.updateEnterprises()
      this.enterpriseName = ''
    },
    async addBalanceToEntreprise() {
      const { contract, enterpriseName, donation} = this
      await contract.methods.addBalanceToEntreprise(donation, enterpriseName).send()
      await this.updateEnterprises()
      await this.updateAccount()
      this.enterpriseName = ''
      this.donation = 0
    },
    async createProjectEntreprise() {
      const { contract, project_name, enterpriseName} = this
      await contract.methods.createProjectEntreprise(project_name, enterpriseName).send()
      await this.updateProjects()
      this.project_name = ''
      this.enterpriseName = ''
    },
    async addBalanceToProjectUsingEntreprise() {
      const { contract, project_name, donation, enterpriseName} = this
      await contract.methods.addBalanceToProjectUsingEntreprise(donation, project_name, enterpriseName).send()
      await this.updateProjects()
      await this.updateEnterprises()
      this.enterpriseName = ''
      this.project_name = ''
      this.donation = 0
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
    async createBounty() {
      const { contract, project_name, budget, bountyDescription} = this
      await contract.methods.createBounty(project_name, bountyDescription, budget).send()
      await this.updateProjects()
      this.project_name = ''
      this.budget = 0
      this.bountyDescription = ''
    },
    async solveBounty() {
      const { contract, project_name, bountyID, bountyCorrection} = this
      await contract.methods.solveBounty(project_name, bountyID, bountyCorrection).send()
      await this.updateProjects()
      await this.updateAccount()
      this.project_name = ''
      this.bountyID = 0
      this.bountyCorrection = ''
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
  gap: 24px;
  display: flex;
  flex-direction: row;
  flex-wrap: wrap;
  justify-content: flex-start;
  align-content: flex-start;
  align-items: flex-start;

  /*display: grid;
  align-items: center;
  grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
  grid-gap: 24px;
  margin: auto;
  */
}
.card-home-wrapper{
  width: 400px;
  min-height: 300px;
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
