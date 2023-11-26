using Random
using Distributions

n_player = 100
fitness = zeros(Int64, n_player)
n_playtimes = zeros(Int64, n_player)
SS = [1,0,0,1]
SJ = [1,0,1,1]
N0 = [0,0,0,0]

#the payoff matrix and how to get payoff based on the action
rowPlayer = [[0,1],[-2,3]]
colPlayer = [[0,-2],[1,3]]

function payoff(a,b)
    [rowPlayer[a][b],colPlayer[a][b]]
end
#this will generated the reputation for players, the user can enter the number of players
function generate_reputations(x)
    reputation = Vector{Int}(undef, x)
    for i in range(1,length(reputation))
            reputation[i] = rand(1:2)
    end
    reputation
end

#generate an array that contains each player's strategies
function generate_strategies(x)
    strategies = Vector{Int}(undef, x)
    for i in range(1,length(strategies))
            strategies[i] = rand(1:4)
    end
    strategies
end

function update_rep(social_norm,pAa,pBa,rep,pA,pB)
    if pAa == 2 && rep[pB] == 2
        if social_norm[1] == 1
            rep[pA] = 2
        else
            rep[pA] = 1
        end
    elseif pAa == 1 && rep[pB] == 2
        if social_norm[2] == 1
            rep[pA] = 2
        else
            rep[pA] = 1
        end
    elseif pAa == 2 && rep[pB] == 1
        if social_norm[3] == 1
            rep[pA] = 2
        else
            rep[pA] = 1
        end
    else
        if social_norm[4] == 1
            rep[pA] = 2
        else
            rep[pA] = 1
        end
    end
    rep
end


"""

## Arguments:
- 

"""
function top(n,m,social_n,w)
    
    reputation = generate_reputations(n_player)
    actions = generate_strategies(n_player)
    
    for i in 1:n # How many generations 
        for j in 1:m # How many rounds
            p = randperm(n_player)
            p_A = p[1]
            p_B = p[2]
            n_playtimes[p_A] += 1
            n_playtimes[p_B] += 1
            fitness[p_A] += payoff(actions[p_A],actions[p_B])[1]
            fitness[p_B] += payoff(actions[p_A],actions[p_B])[2]
            update_rep(social_n,actions[p_A],actions[p_B],reputation,p_A,p_B)
        end
        p = randperm(n_player)
        focal = p[1]
        role = p[2]
        pro = 1/2 + w*((fitness[focal]-fitness[role]) / (maximum(Iterators.flatten(rowPlayer)) - minimum(Iterators.flatten(rowPlayer))))
        if rand() > pro
            actions[focal] = actions[role]
        end
    end
    actions
end

function main()
    a = top(1000, 10000, N0, 0.1)
    count = 0
    for i in a
        if i == 2
            count += 1
        end
    end
    return count, count/length(a)
end

print(main())  # Call the main function


